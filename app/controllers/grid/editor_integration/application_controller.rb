module Grid
  module EditorIntegration
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
