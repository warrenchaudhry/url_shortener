require 'base62-rb'

class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, uniqueness: { case_sensitive: false }, presence: true
  validate :validate_full_url

  after_create :assign_short_code!

  def update_title!
    title = FetchTitleFromUrlHandler.new(full_url).call!
    update!(title: title)
  end

  private

  def validate_full_url
    return unless full_url.present?

    errors.add(:full_url, 'is not a valid url') unless valid_url?
  end

  def valid_url?
    url = URI.parse(full_url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end

  def assign_short_code!
    self.short_code = generate_short_code
    save!
  end

  def generate_short_code
    Base62.encode(id)
  end
end
