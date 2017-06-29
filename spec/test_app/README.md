How to set up applications
==========================

To begin with, we recommend to review the [application initialization file](config/initializers/grid_editor_integration.rb).

Parameters for the SetkaEditor server are mandatory.

You also need to specify parameters for a storage (local or AWS).
**Grid::EditorIntegration.version_file_name** parameter must contain the filename in which a parameter to reset browser cache will be stored. It is necessary for the cache to be reset each time the SetkaEditor is updated and for the cache to operate between the updates.

You can also store this information in DB, memcached, etc. To do this, you need to override the read_version and **update_version** methods in the [Utils file](lib/grid/editor_integration/utils.rb).
