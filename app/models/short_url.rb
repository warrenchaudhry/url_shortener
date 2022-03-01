class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, uniqueness: { case_sensitive: false }, presence: true
  validate :validate_full_url

  def short_code
  end

  def update_title!
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
end
