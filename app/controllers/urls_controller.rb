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
      redirect_to new_url_path, notice: { message: outcome.errors.message.values.join("\n"), severity: 'error' }
    end
  end

  def show
    load_url
  end

  private

  def create_url_params
    params.require(:url).permit(:original_url).to_h
  end

  def load_url
    @url = Url.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to urls_path
  end
end
