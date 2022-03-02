require 'open-uri'

class FetchTitleFromUrlHandler
  def initialize(url)
    @url = url
  end

  def call!
    open(url) do |f|
      doc = Nokogiri::HTML(f)
      doc.at_css('title').text
    end
  rescue Errno::ENOENT
    raise ::InvalidUrlError, "Invalid URL: #{url}"
  end

  private

  attr_reader :url
end