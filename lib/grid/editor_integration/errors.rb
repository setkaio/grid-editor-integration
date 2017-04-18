module Grid
  module EditorIntegration
    module Errors
      class BaseError < StandardError; end
      class InvalidToken < BaseError; end
      class InvalidConfig < BaseError; end
      class NotAuthorized < BaseError; end
      class DownloadFailed < BaseError; end
    end
  end
end
