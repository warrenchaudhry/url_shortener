class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    render json: { hello: 'world' }
  end

  def create
  end

  def show
  end

end
