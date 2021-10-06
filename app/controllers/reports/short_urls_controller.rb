class Reports::ShortUrlsController < AuthorizableController
  before_action :check_short_url, only: :show

  def index
    @short_url_stats = ShortUrlClickStats.new(user_id: current_user.id, since: Time.at(0)).results
  end

  def show
    @url_clicks = UrlClick.where(short_url_id: @short_url.id).map { |c| UrlClickPresenter.new(c) }
  end

  private

  def check_short_url
    @short_url = ShortUrl.find_by_url_hash(params[:id])
    render_404 unless @short_url
  end
end
