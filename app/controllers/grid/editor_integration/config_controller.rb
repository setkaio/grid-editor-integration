module Grid
  module EditorIntegration
    class ConfigController < ApplicationController
      include Grid::EditorIntegration::ApplicationHelper
      include Grid::EditorIntegration::EditorConfig
      include Grid::EditorIntegration::CheckToken
    end
  end
end
