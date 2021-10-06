class RedirectionController < ApplicationController
  before_action :check_redirectable, only: :show
  after_action :track_click, only: :show

  def show
    expires_in 90, private: true
    redirect_to @original_url, status: :moved_permanently
  end

  private

  def track_click
    return unless @original_url
    UrlClick.track(
      url_hash: @short_url.url_hash, short_url_id: @short_url.id, original_url_id: @short_url.url_id,
      ip: client_ip
    )
  end

  # Add additional rules here if necessary
  def check_redirectable
    @short_url = ShortUrl.find_by_url_hash(params[:url_hash])
    @original_url = @short_url&.original_url
    render('show', locals: { request_url: request.url }, layout: 'application_public', status: 404) unless @original_url
  end

  def client_ip
    request.headers['HTTP_X_FORWARDED_FOR']&.split(',')&.last
  end
end
