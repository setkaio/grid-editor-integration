Grid Editor Integration
=======================

This project allows you to integrate [SetkaEditor](https://setka.io/editor/) into applications based on RubyOnRails.

Gem provides the ability to [download and update](app/controllers/grid/editor_integration/config_controller.rb) the plugin and to [create snippets](app/controllers/grid/editor_integration/snippets_controller.rb).

Since the plugin can be stored not only in the local file system, we implemented two types of [storage](lib/grid/editor_integration/storages/abstract.rb) - [file](lib/grid/editor_integration/storages/file.rb) and [S3](lib/grid/editor_integration/storages/s3.rb). In addition you can implement and use your own custom storage class.

We also recommend you to check out [application sample](spec/test_app) that uses integration.

Installation
-------------
Add the gem line 'grid-editor-integration' in Gemfile, or install gem manually.
```ruby
gem 'grid-editor-integration', git: 'ssh://git@grid-editor-integration.git'
```

Implementation
--------------
You need to set up the following parameters:
```ruby
Grid::EditorIntegration.token
Grid::EditorIntegration.storage
```
By default, the [File storage](lib/grid/editor_integration/storages/file.rb) will be used. All default parameters and their default values can be viewed [here](lib/grid/editor_integration.rb).


This uses MIT-LICENSE
