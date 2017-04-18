module Grid
  module EditorIntegration
    class SnippetsController < ApplicationController
      include Grid::EditorIntegration::ApplicationHelper

      def create
        snippet_url = URI(Grid::EditorIntegration.snippet_url)
        req_body = {
          token: Grid::EditorIntegration.token,
          theme_id: params[:themeId],
          snippet: {
            name: params[:name],
            code: params[:code]
          }
        }

        req = Net::HTTP::Post.new(snippet_url, 'Content-Type' => 'application/json')
        req.body = req_body.to_json
        res = Net::HTTP.start(
          snippet_url.hostname,
          snippet_url.port,
          use_ssl: snippet_url.scheme == 'https') { |http| http.request(req) }

        render text: res.body
      end
    end
  end
end
