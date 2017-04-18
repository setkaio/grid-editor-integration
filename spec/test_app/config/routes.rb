Rails.application.routes.draw do
  mount Grid::EditorIntegration::Engine => "/grid_editor_integration"
end
