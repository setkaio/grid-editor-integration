require 'active_support/concern'

module Grid
  module EditorIntegration
    module CheckToken
      extend ActiveSupport::Concern

      included do
        before_action :check_token
        rescue_from Grid::EditorIntegration::Errors::InvalidToken,
          with: :unauthorized
      end

      protected

        def check_token
          if params["token"] != Grid::EditorIntegration.token
            raise Grid::EditorIntegration::Errors::InvalidToken
          end
        end

        def unauthorized
          render nothing: true, status: 403
        end
    end
  end
end
