require 'open-uri'

class FetchTitleFromUrlHandler
  def initialize(url)
    @url = url
  end

  def call!
    html = open(url).read
    doc = Nokogiri::HTML(html)
    doc.at_css('title').text
  rescue Errno::ENOENT
    raise ::InvalidUrlError, "Invalid URL: #{url}"
  end

  private

  attr_reader :url
end