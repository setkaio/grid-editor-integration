require 'spec_helper'

describe Grid::EditorIntegration::EditorConfig, type: :request do
  context 'update from configurator' do
    let(:editor_url) do
      '/grid_editor_integration/update_editor_config'
    end

    it 'push request should update editor on good request' do
      post editor_url,
      {
        "token" => Grid::EditorIntegration.token,
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
