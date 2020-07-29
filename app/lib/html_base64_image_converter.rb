class HtmlBase64ImageConverter
  attr_reader :html_str, :uploader

  HTML_IMAGE_SRC_REGEXP = /data:[\w\/]+;base64,(?<base64_data>[^\\"]+)/
  HTML_BASE64_IMAGE_REGEXP = /data:\w+\/(?<extension>\w+);base64,(?<base64_data>[^\\"]+)/

  def initialize(html_str, uploader)
    @html_str = html_str
    @uploader = uploader
  end

  def replace_images(prefix = '', suffix = '')
    @html_str = @html_str.gsub(HTML_IMAGE_SRC_REGEXP).with_index do |match, index|
      "#{prefix}#{upload_images[index]}#{suffix}"
    end
  end

  def extract_base64_images
    # returns an array os arrays containing the file extension and base64 data
    # [[extension1, base64_data1], [extension2, base64_data2] etc]
    html_str.scan(HTML_BASE64_IMAGE_REGEXP)
  end

  def upload_images
    urls = []
    extract_base64_images.each do |image|
      # data = image[1]
      # extension = image[0]
      urls << uploader.store(image[1], image[0])
    end
    urls
  end
end