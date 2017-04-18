require "grid/editor_integration/engine"
require "grid/editor_integration/utils"

module Grid
  module EditorIntegration
    ###############################################################
    # SetkaEditor integration settings. Change defaults only if you know what you are doing
    ###############################################################
    mattr_accessor :token, :integration_server_url
    mattr_reader :current_build_path, :snippet_path

    @@integration_server_url = "https://editor.setka.io"
    @@current_build_path = "/api/v1/custom/builds/current"
    @@snippet_path = "/api/v1/custom/snippets"
    ###############################################################

    ###############################################################
    # config structure
    ###############################################################
    mattr_reader :plugin_files, :theme_files, :content_editor_files,
      :plugin_file, :theme_file, :content_editor_file,
      :plugin_file_extensions, :theme_file_extensions, :content_editor_file_extensions,
      :editor_file_types

    @@plugin_files = "plugins"
    @@plugin_file = "public"
    @@plugin_file_extensions = ["js"]

    @@theme_files = "theme_files"
    @@theme_file = "theme"
    @@theme_file_extensions = ["css", "json"]

    @@content_editor_files = "content_editor_files"
    @@content_editor_file = "content_editor"
    @@content_editor_file_extensions = ["js", "css"]

    @@editor_file_types = [:plugin, :theme, :content_editor].freeze
    ###############################################################

    ###############################################################
    # network settings
    ###############################################################
    mattr_accessor :all_requests_timeout, :request_timeout

    # timeout for one file downloading
    @@request_timeout = 10
    # common timeout
    @@all_requests_timeout = 60
    ###############################################################

    ###############################################################
    # Storage settings and miscellaneous
    ###############################################################
    mattr_accessor :storage, :path, :cdn_url, :options_for_storage,
      :version_file_name
    # storage name
    @@storage = "file"
    # url to your cdn
    # empty - current site url
    @@cdn_url = ""
    # path to SetkaEditor in storage
    @@path = "editor"
    # options for
    @@options_for_storage = {}
    # place for current version and ts of plugin
    @@version_file_name = "#{Rails.root}/tmp/grid_editor_version"
    ###############################################################

    CONTENT_TYPES = {
      "js" => "application/javascript",
      "json" => "application/json",
      "css" => "text/css"
    }

    def self.current_build_url() "#{integration_server_url}#{current_build_path}"; end

    def self.snippet_url() "#{integration_server_url}#{snippet_path}"; end
  end
end
