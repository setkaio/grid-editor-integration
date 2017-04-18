module Grid
  module EditorIntegration
    module ApplicationHelper

      def editor_js_url
        grid_editor_files_url("#{Grid::EditorIntegration.content_editor_files}/#{Grid::EditorIntegration.content_editor_file}.js")
      end

      def editor_css_url
        grid_editor_files_url("#{Grid::EditorIntegration.content_editor_files}/#{Grid::EditorIntegration.content_editor_file}.css")
      end

      def editor_theme_css_url
        grid_editor_files_url("#{Grid::EditorIntegration.theme_files}/#{Grid::EditorIntegration.theme_file}.css")
      end

      def plugin_js_url
        grid_editor_files_url("#{Grid::EditorIntegration.plugin_files}/#{Grid::EditorIntegration.plugin_file}.js")
      end

      def grid_editor_files_url(file_name)
        "#{storage.file_url(file_name)}?_dc=#{Grid::EditorIntegration::Utils.read_version}"
      end

      def storage(version = '1')
        @storage ||= Grid::EditorIntegration::Storages::Factory.create_storage(
          Grid::EditorIntegration.storage,
          Grid::EditorIntegration.path,
          version,
          Grid::EditorIntegration.cdn_url,
          Grid::EditorIntegration.options_for_storage)
      end

      def width_presets; []; end
    end
  end
end
