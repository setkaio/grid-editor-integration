require 'active_support/concern'

module Grid
  module EditorIntegration
    module EditorConfig
      extend ActiveSupport::Concern

      included do
        rescue_from Grid::EditorIntegration::Errors::InvalidConfig,
          with: :bad_request
      end

      def update
        raise Grid::EditorIntegration::Errors::InvalidConfig unless params["data"]
        Grid::EditorIntegration::Utils.download_editor(params["data"])

        render nothing: true
      end

      protected
        def bad_request
          render nothing: true, status: 422
        end
    end
  end
end
