class UrlsController < AuthorizableController
  # @!method current_user
  #   @return [User]

  def index
    @urls = current_user.urls
  end

  def new
    @new_url = Url.new
  end

  def create
    outcome = Urls::Create.run(user: current_user, **create_url_params)

    if outcome.success?
      redirect_to url_path(outcome.result)
    else
      @new_url = Url.new(create_url_params)
      redirect_to new_url_path
    end
  end

  def show
    load_url
  end

  private

  def create_url_params
    params.permit(:original_url, :title).to_h
  end

  def load_url
    @url = Url.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to urls_path
  end
end
