require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../test_app/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:example, file_storage: true) do
    Grid::EditorIntegration.cdn_url = ""
    Grid::EditorIntegration.storage = "file"
    Grid::EditorIntegration.options_for_storage = {
      prefix: ENV['CI_JOB_ID'],
      path: "#{Dir.pwd}/spec/test_app/public/"
    }
  end

  config.before(:example, aws_storage: true) do
    WebMock.disable_net_connect!(allow: %r{rgw.lookatmedia.ru})

    unless ENV['AWS_ENDPOINT']
      skip "Set S3 storage params to test this feature"
    end

    Grid::EditorIntegration.cdn_url = "#{ENV['AWS_PROTOCOL']}://#{ENV['AWS_ENDPOINT']}/#{ENV['AWS_BUCKET']}"
    Grid::EditorIntegration.storage = "s3"
    Grid::EditorIntegration.options_for_storage = {
      prefix: ENV['CI_JOB_ID'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      use_ssl: false,
      s3_protocol: ENV['AWS_PROTOCOL'],
      s3_endpoint: ENV['AWS_ENDPOINT'],
      s3_region: ENV['AWS_REGION'],
      s3_force_path_style: true,
      bucket: ENV['AWS_BUCKET'],
      content_encoding: 'gzip'
    }
  end
end
