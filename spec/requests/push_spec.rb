require 'spec_helper'

describe Grid::EditorIntegration::EditorConfig, type: :request do
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

  context 'update from configurator', file_storage: true do
    before(:each) do
      stub_request(:get, "https://ceditor.setka.io/public.js").and_return(status: 200, body: "")
      stub_request(:get, "https://ceditor.setka.io/theme.min.css").and_return(status: 200, body: "")
      stub_request(:get, "https://ceditor.setka.io/theme.json").and_return(status: 200, body: "")
      stub_request(:get, "https://ceditor.setka.io/editor.min.css").and_return(status: 200, body: "")
      stub_request(:get, "https://ceditor.setka.io/editor.min.js").and_return(status: 200, body: "")
    end

    let(:editor_url) do
      '/grid_editor_integration/update_editor_config'
    end

    it 'push request should update editor on good request' do
      post editor_url, editor_config
      expect(response.status).to eq(200)
    end

    it 'push request should not update editor without token' do
      post editor_url, { "token" => "" }
      expect(response.status).to eq(403)
    end

    it 'push request should not update editor on bad config' do
      post editor_url, { "token" => Grid::EditorIntegration.token, data: {f: :f} }
      expect(response.status).to eq(422)
    end
  end
end
