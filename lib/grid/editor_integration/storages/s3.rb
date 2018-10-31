require "grid/editor_integration/storages/abstract"
require "aws-sdk-v1"

module Grid
  module EditorIntegration
    module Storages
      class S3 < AbstractStorage
        attr_accessor :bucket, :content_encoding
        attr_reader :storage

        def initialize(path = nil, cdn_url = "", options = {})
          super

          self.bucket = options[:bucket]
          self.content_encoding = options[:content_encoding]

          @storage = AWS::S3.new(options)
        end

        def file_exists?(file_name)
          storage.buckets[bucket].objects[full_file_name(file_name)].exists?
        end

        def save_content_in_file(current_content, file_name, options = {})
          o = storage.buckets[bucket].objects.create(full_file_name(file_name),
            current_content,
            acl: :public_read,
            content_type: options[:content_type])
        end

        def full_file_name(file_name)
          ::File.join(path, file_name)
        end

        def get_content_by_file_name(file_name)
          res = storage.
            buckets[bucket].
            objects[full_file_name(file_name)].
            read.
            force_encoding(Encoding::UTF_8)
        end

        def clear
          storage.buckets[bucket].
            objects.
            with_prefix(path).
            each { |o| o.delete }
        end
      end
    end
  end
end
