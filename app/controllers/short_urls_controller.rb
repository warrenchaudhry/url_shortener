class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    short_urls = ShortUrl.order(click_count: :desc).limit(100)
    render json: { urls: short_urls.map(&:public_attributes) }
  end

  def create
    short_url_params = params.permit(:full_url)
    short_url = ShortUrl.new(short_url_params)
    if short_url.save
      UpdateTitleJob.perform_later(short_url.id)
      render json: short_url.public_attributes
    else
      render json: { errors: short_url.errors.full_messages }
    end
  end

  def show
    short_url = ShortUrl.find_by!(short_code: params[:id])
    short_url.increment!(:click_count)
    redirect_to short_url.full_url
  rescue ActiveRecord::RecordNotFound
    head 404
  end

end
