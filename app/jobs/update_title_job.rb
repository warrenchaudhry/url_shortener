class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    @short_url = ShortUrl.find(short_url_id)
    title = FetchTitleFromUrlHandler.new(@short_url.full_url).call!
    @short_url.update!(title: title)
  end
end
