require 'net/http'
require "grid/editor_integration/errors"
require "grid/editor_integration/downloader"

module Grid
  module EditorIntegration
    module Utils
      def self.grid_request(url)
        uri = URI(url)
        req = Net::HTTP::Get.new(uri, {'Content-Type' => 'application/json'})
        req.body = { token: Grid::EditorIntegration.token }.to_json
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end
        case res
        when Net::HTTPSuccess then
          yield res
        when Net::HTTPUnauthorized
          raise Grid::EditorIntegration::Errors::NotAuthorized
        end
      end

      def self.init_sync
        grid_request(Grid::EditorIntegration.current_build_url) do |res|
          JSON.parse(res.body)
        end
      end

      def self.get_config
        init_sync
      end

      def self.download_editor(cfg = nil)
        downloader = Grid::EditorIntegration::Downloader.new(cfg ? cfg : get_config)
        downloader.download

        update_version
      end

      def self.clear
        storage = Grid::EditorIntegration::Storages::Factory.create_from_global_settings
        storage.clear
      end

      def self.read_version
        if ::File.exists?(Grid::EditorIntegration.version_file_name)
          File.read(Grid::EditorIntegration.version_file_name)
        else
          "Missed grid editor version file"
        end
      end

      def self.update_version
        f = ::File.new(Grid::EditorIntegration.version_file_name, 'wb')
        f.write("1_#{Time.zone.now.to_i}")
        f.close
      end
    end
  end
end
