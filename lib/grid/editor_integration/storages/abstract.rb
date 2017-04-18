module Grid
  module EditorIntegration
    module Storages
      class AbstractStorage
        attr_accessor :path, :version, :cdn_url

        def initialize(path = nil, version = nil, cdn_url = "", options = {})
          self.path = path
          self.version = version
          self.cdn_url = cdn_url
        end

        def file_exists?(file_name) raise NotImplementedError; end

        def path_exists?(path_name) raise NotImplementedError; end

        def create_path() raise NotImplementedError; end

        def create_versioned_path() raise NotImplementedError; end

        def save_content_in_file(content, file_name, options = {})
          raise NotImplementedError
        end
        
        def file_url(file_name) "#{cdn_url}/#{path}/#{version}/#{file_name}"; end

        def get_content_by_file_name(file_name) raise NotImplementedError; end

        def clear() raise NotImplementedError; end
      end
    end
  end
end
