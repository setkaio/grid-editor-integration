#parameters required for SetkeEditor's server
Grid::EditorIntegration.token = ENV['GRID_EDITOR_TOKEN']
Grid::EditorIntegration.storage = ENV['GRID_EDITOR_STORAGE']

#url to your cdn
Grid::EditorIntegration.cdn_url = ""
#where will be stored timestamp for disable browser caching
Grid::EditorIntegration.version_file_name = "#{Rails.root}/tmp/grid_editor_version"
#path inside storage
Grid::EditorIntegration.path = "editor"

#You can choose where to store editor - in local folder or in AWS.
#You can implement some other kind of storage and use it.
case Grid::EditorIntegration.storage
when 'file'
  #this is path to local storage
  Grid::EditorIntegration.options_for_storage = {
    path: "#{Rails.public_path}"
  }
when 'S3'
  #these parameters are for your AWS storage
  Grid::EditorIntegration.options_for_storage = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    use_ssl: false,
    s3_endpoint: ENV['AWS_ENDPOINT'],
    s3_region: ENV['AWS_REGION'],
    s3_force_path_style: true,
    bucket: ENV['AWS_BUCKET']
  }
end
