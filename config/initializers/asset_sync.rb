AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.aws_access_key_id = 'AKIAIQPQIW7MTKYA5MVA' #ENV['AWS_ACCESS_KEY_ID']
  config.aws_secret_access_key = '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' #ENV['AWS_SECRET_ACCESS_KEY']
  config.fog_directory = 'mysugar-assets' #ENV['FOG_DIRECTORY']
  
  # Increase upload performance by configuring your region
  # config.fog_region = 'eu-west-1'
  #
  # Don't delete files from the store
  # config.existing_remote_files = "keep"
  #
  # Automatically replace files with their equivalent gzip compressed version
  # config.gzip_compression = true
  #
  # Use the Rails generated 'manifest.yml' file to produce the list of files to 
  # upload instead of searching the assets directory.
  # config.manifest = true
  #
  # Fail silently.  Useful for environments such as Heroku
  # config.fail_silently = true
end
