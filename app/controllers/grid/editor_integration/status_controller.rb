module Grid
  module EditorIntegration
    class ConfigController < ApplicationController
      include Grid::EditorIntegration::ApplicationHelper
      include Grid::EditorIntegration::CheckToken

      def server
        render nothing: true
      end

      def company
        render nothing: true
      end
    end
  end
end
