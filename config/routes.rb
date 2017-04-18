Grid::EditorIntegration::Engine.routes.draw do
  get 'test_page', to: 'test_page#index'

  resources 'snippets', only: [:create]

  post 'update_editor_config', to: 'config#update'
  post 'server_status', to: 'status#server'
  post 'company_status', to: 'status#company'
end
