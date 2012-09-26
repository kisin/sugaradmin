  # interpolate in paperclip
  Paperclip.interpolates :access_token  do |attachment, style|
    attachment.instance.access_token
  end