class UrlInfoCrawler
  def initialize url
    @url = parseHttp(url)
  end

  def parseHttp url
    if not url.starts_with? "http://" and not url.starts_with? "https://"
      url = "http://#{url}"
    end
    url
  end

  def fetch
    @nokogiri = Nokogiri::HTML(open(@url, :allow_redirections => :all).read())
    # clean noscript
    @nokogiri.css('noscript').each {|i| i.content = '' }
    @nokogiri
  end

  def title
    title_node = @nokogiri.css('title')
    if title_node.size > 0
      @nokogiri.css('title').first.text.gsub("\n", "").strip
    else
      "Sem título"
    end
  end

  def description
    description_node = @nokogiri.xpath("//meta[@name='description']/@content")

    if description_node.size > 0
      return description_node.first.value.gsub("\n", "").strip
    else
      nil
    end
  end

  def parse_image_host image_url
    if not image_url.starts_with? "http://" and not image_url.starts_with? "https://"
      return (URI(@url) + image_url).to_s
    else
      return image_url
    end
  end

  def image
    image_node = @nokogiri.xpath("//meta[@property='og:image']/@content")

    if image_node.size > 0 and not /missing/.match image_node.first.value
      return parse_image_host image_node.first.value
    end

    image_nodes = @nokogiri.css("[role='main'] img")
    if image_nodes.size > 0
      src = image_nodes.first.attr('src')
      if src.present?
        return parse_image_host src
      end
    end

    image_nodes = @nokogiri.css("img")
    if image_nodes.size > 0
      image_nodes = image_nodes.select do |node|
        node.attr('src').present?
      end

      if image_nodes.size > 0
        return parse_image_host image_nodes.first.attr('src')
      end
    end

    return nil
  end

  def info
    fetch
    {
      title: title,
      description: description,
      image: image,
    }
  end
end
