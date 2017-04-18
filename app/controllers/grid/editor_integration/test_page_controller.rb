module Grid
  module EditorIntegration
    class TestPageController < ApplicationController
      include Grid::EditorIntegration::ApplicationHelper

      Post = Struct.new(:body, :images, :layout, :theme)

      def index; @post = Post.new("Test", []); end
    end
  end
end
