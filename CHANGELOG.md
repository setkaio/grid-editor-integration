## [0.1.0]
### Changed
- editor version parameter from `Grid::EditorIntegration::Storages::AbstractStorage` initialization
- editor version parameter from `create_storage` and `create_from_global_settings` methods of `Grid::EditorIntegration::Storages::Factory`
- editor version from editor files urls

    You need to redownload editor files by `RAILS_ENV=production bundle exec rake grid:editor_integration:download_editor`