class Reports::ShortUrlsController < AuthorizableController
  def index
    @short_url_stats = ShortUrlClickStats.new(user_id: current_user.id, since: Time.at(0)).results
  end
end
