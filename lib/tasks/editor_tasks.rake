namespace :grid do
  namespace :editor_integration do
    desc "Initial sync"
    task :init_sync => [:environment] do
      Grid::EditorIntegration::Utils.init_sync
    end

    desc "Get config"
    task :get_config => [:environment] do
      p Grid::EditorIntegration::Utils.get_config
    end

    desc "Downoload editor"
    task :download_editor => [:environment] do
      Grid::EditorIntegration::Utils.download_editor
    end
  end
end
