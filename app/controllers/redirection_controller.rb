class RedirectionController < ApplicationController
  def show
    short_url = ShortUrl.find_by_url_hash(params[:url_hash])&.original_url
    if short_url
      expires_in 90, private: true
      redirect_to short_url, status: :moved_permanently
    else
      render 'show', locals: { request_url: request.url }, layout: 'application_public', status: 404
    end
  end
end
