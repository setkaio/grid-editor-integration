require "grid/editor_integration/storages/abstract"
require "fileutils"

module Grid
  module EditorIntegration
    module Storages
      class File < AbstractStorage
        attr_reader :storage_path

        def initialize(path = nil, version = nil, cdn_url = "", options = {})
          super

          @storage_path = options[:path]
        end

        def save_content_in_file(current_content, file_name, options = {})
          full_file_name = full_local_file_name(file_name)
          create_path_for_file(full_file_name)
          f = ::File.new(full_file_name, 'wb')
          f.write(current_content)
          f.close
        end

        def file_exists?(file_name) ::File.exists?(full_local_file_name(file_name)); end

        def path_exists?(path) Dir.exists? path; end

        def create_path_for_file(path)
          create_path(path.split('/')[0..-2].join('/'))
        end

        def create_path(path)
          path[1..-1].split('/').inject('/') do |current_path, folder_name|
            current_path += folder_name + '/'
            ::Dir.mkdir(current_path) unless path_exists? current_path
            current_path
          end
        end

        def full_local_file_name(file_name) "#{versioned_path}/#{file_name}"; end

        def create_versioned_path() create_path(versioned_path); end

        def versioned_path() "#{storage_path}/#{path}/#{version}"; end
        
        def clear()
          FileUtils.rm_dir(versioned_path, true) if path_exists?(versioned_path)
        end

        def get_content_by_file_name(file_name)
          ::File.read(full_local_file_name(file_name))
        end
      end
    end
  end
end
