require "grid/editor_integration/storages/factory"
require 'timeout'
require 'digest'

module Grid
  module EditorIntegration
    class Downloader
      def initialize(config)
        @storage = Grid::EditorIntegration::Storages::Factory.create_storage(
          Grid::EditorIntegration.storage,
          Grid::EditorIntegration.path,
          Grid::EditorIntegration.cdn_url,
          Grid::EditorIntegration.options_for_storage)

        @md5 = ::Digest::MD5.new

        @urls = {}
        Grid::EditorIntegration.editor_file_types.each do |file_type|
          file_type_name = Grid::EditorIntegration.send("#{file_type}_files")
          unless config[file_type_name]
            raise Grid::EditorIntegration::Errors::InvalidConfig
          end
          @urls[file_type] = cfg_array(config[file_type_name]).collect do |item|
            generate_item(item)
          end
        end
      end

      def download
        Timeout::timeout(
          Grid::EditorIntegration.all_requests_timeout,
          Grid::EditorIntegration::Errors::DownloadFailed) do
          while (!@urls.all? do |key, url_array|
            url_array.all? { |url_item| url_item[:content] }
          end)
            download_files(@urls)
          end
        end

        @urls.each do |file_type, file_array|
          path_with_file_type = "#{Grid::EditorIntegration.send("#{file_type}_files")}/#{Grid::EditorIntegration.send("#{file_type}_file")}"
          file_array.each do |file|
            @storage.save_content_in_file(file[:content],
              "#{path_with_file_type}.#{file[:filetype]}",
              file[:content_options])
          end
        end
      end

      private
        def cfg_array(items)
          return Array === items ?
            items :
            items.inject([]) { |arr, (k, v)| arr[k.to_i] = v; arr }
        end

        def generate_item(item)
          {
            url: item["url"],
            md5: item["md5"],
            filetype: item["filetype"],
            content_options: {
              content_type: Grid::EditorIntegration::CONTENT_TYPES[item["filetype"]]
            }
          }
        end

        def download_files(urls)
          @urls.each do |key, url_array|
            url_array.each do |url_item|
              if url_item[:content].nil?
                Timeout::timeout(Grid::EditorIntegration.request_timeout) do
                  t = Thread.new { download_file(url_item) }
                  t.join
                end
              end
            end
          end
        end

        def download_file(url_item)
          res = Net::HTTP.get_response(URI(url_item[:url]))
          content = res.body
          if url_item["md5"].nil? || url_item["md5"] == "" || url_item["md5"] == md5.digest(content)
            url_item[:content] = content
          end
        end
    end
  end
end
