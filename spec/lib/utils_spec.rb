require "spec_helper"

describe Grid::EditorIntegration::Utils do
  context "Initial sync" do
    let(:subscription) { create(:subscription) }

    it 'fails without token' do
      old_token = Grid::EditorIntegration.token
      Grid::EditorIntegration.token = ""
      expect { Grid::EditorIntegration::Utils.init_sync }.to(
        raise_error(Grid::EditorIntegration::Errors::NotAuthorized))

      Grid::EditorIntegration.token = old_token
    end

    it 'success with correct token' do
      expect { Grid::EditorIntegration::Utils.init_sync }.not_to(raise_error)
    end
  end

  context "Download editor" do
    def check_download
      storage = Grid::EditorIntegration::Storages::Factory.create_from_global_settings('1')

      cfg = Grid::EditorIntegration::Utils.get_config

      Grid::EditorIntegration::Utils.clear(cfg["content_editor_version"])

      expect { Grid::EditorIntegration::Utils.download_editor(cfg) }.not_to(raise_error)

      Grid::EditorIntegration.editor_file_types.each do |file_type|
        path_with_file_type = "#{Grid::EditorIntegration.send("#{file_type}_files")}/#{Grid::EditorIntegration.send("#{file_type}_file")}"
        Grid::EditorIntegration.send("#{file_type}_file_extensions").each do |ext|
          name = "#{path_with_file_type}.#{ext}"
          expect(storage.file_exists?(name)).to be_truthy

          if Grid::EditorIntegration.cdn_url!=""
            res = Net::HTTP.get_response(URI(storage.file_url(name)))
            expect(res.code).to eq '200'
          end
        end
      end

      Grid::EditorIntegration::Utils.clear(cfg["content_editor_version"])
    end

    it 'success v1 on file system' do
      Grid::EditorIntegration.cdn_url = ""
      Grid::EditorIntegration.storage = "file"
      Grid::EditorIntegration.options_for_storage = {
        path: "#{Dir.pwd}/spec/test_app/public/"
      }

      check_download
    end

    it 'success v1 on aws system' do
      unless ENV['AWS_ENDPOINT']
        skip "Set S3 storage params to test this feature"
      end
      Grid::EditorIntegration.cdn_url = ENV['GRID_CDN_URL'] || ENV['AWS_ENDPOINT']
      Grid::EditorIntegration.storage = "s3"
      Grid::EditorIntegration.options_for_storage = {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        use_ssl: false,
        s3_protocol: ENV['AWS_PROTOCOL'],
        s3_endpoint: ENV['AWS_ENDPOINT'],
        s3_region: ENV['AWS_REGION'],
        s3_force_path_style: true,
        bucket: ENV['AWS_BUCKET'],
        content_encoding: 'gzip'
      }

      check_download
    end
  end
end
