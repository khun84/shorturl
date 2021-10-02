class UrlsController < AuthorizableController
  # @!method current_user
  #   @return [User]

  def index
    @urls = current_user.urls
  end

  def new
    @new_url = Url.new
  end
end
