require "spec_helper"

describe Grid::EditorIntegration::Utils do
  let(:editor_config) {
    {
        "token" => Grid::EditorIntegration.token,
        "content_editor_version" => "1",
        "data" => {
          "plugins" => [ {
            "url" => "https://ceditor.setka.io/public.js",
            "filetype" => "js"
          } ],
          "theme_files" => [ {
            "id" => 1,
            "url" => "https://ceditor.setka.io/theme.min.css",
            "filetype" => "css"
          }, {
            "id" => 1,
            "url" => "https://ceditor.setka.io/theme.json",
            "filetype" => "json"
          } ],
          "content_editor_files" => [ {
            "id" => 1,
            "url" => "https://ceditor.setka.io/editor.min.css",
            "filetype" => "css"
          }, {
              "id" => 1,
              "url" => "https://ceditor.setka.io/editor.min.js",
              "filetype" => "js"
          } ]
        }
      }
  }

  context "Initial sync" do
    let(:subscription) { create(:subscription) }

    it "fails without token" do
      stub_request(:get, "https://editor.setka.io/api/v1/custom/builds/current").and_return(status: 401, body: '{"error":"Not authorized!"}')

      old_token = Grid::EditorIntegration.token
      Grid::EditorIntegration.token = ""
      expect { Grid::EditorIntegration::Utils.init_sync }.to(
        raise_error(Grid::EditorIntegration::Errors::NotAuthorized))

      Grid::EditorIntegration.token = old_token
    end

    it "success with correct token" do
      stub_request(:get, "https://editor.setka.io/api/v1/custom/builds/current").and_return(status: 200, body: editor_config.to_json)

      expect { Grid::EditorIntegration::Utils.init_sync }.not_to(raise_error)
    end
  end


  context "Download editor" do
    before(:each) do
      stub_request(:get, "https://editor.setka.io/api/v1/custom/builds/current").and_return(status: 200, body: editor_config.to_json)
      stub_request(:get, "https://ceditor.setka.io/public.js").and_return(status: 200, body: "")
      stub_request(:get, "https://ceditor.setka.io/theme.min.css").and_return(status: 200, body: "")
      stub_request(:get, "https://ceditor.setka.io/theme.json").and_return(status: 200, body: "")
      stub_request(:get, "https://ceditor.setka.io/editor.min.css").and_return(status: 200, body: "")
      stub_request(:get, "https://ceditor.setka.io/editor.min.js").and_return(status: 200, body: "")
    end

    def check_download
      storage = Grid::EditorIntegration::Storages::Factory.create_from_global_settings

      cfg = Grid::EditorIntegration::Utils.get_config

      Grid::EditorIntegration::Utils.clear

      expect { Grid::EditorIntegration::Utils.download_editor(cfg["data"]) }.not_to(raise_error)

      Grid::EditorIntegration.editor_file_types.each do |file_type|
        path_with_file_type = "#{Grid::EditorIntegration.send("#{file_type}_files")}/#{Grid::EditorIntegration.send("#{file_type}_file")}"
        Grid::EditorIntegration.send("#{file_type}_file_extensions").each do |ext|
          name = "#{path_with_file_type}.#{ext}"
          expect(storage.file_exists?(name)).to be_truthy

          if Grid::EditorIntegration.cdn_url != ""
            res = Net::HTTP.get_response(URI(storage.file_url(name)))
            expect(res.code).to eq("200")
          end
        end
      end

      Grid::EditorIntegration::Utils.clear
    end

    it "success on file system", file_storage: true do

      check_download
    end

    it "success on aws system", aws_storage: true do
      check_download
    end
  end
end
