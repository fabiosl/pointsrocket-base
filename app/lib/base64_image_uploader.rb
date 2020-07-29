class Base64ImageUploader
  def initialize(uploader)
    @uploader = uploader
  end
  
  def store(data, extension)
    temp_file = Tempfile.new(['image', ".#{extension}"])
    temp_file.binmode
    temp_file.write(Base64.decode64(data))
    temp_file.close
    @uploader.store!(temp_file)
    @uploader.url
  end
end