class ApplicationController < ActionController::Base
  private

  def redirect_if_not_authorize
    unless user_signed_in?
      redirect_to login_path
    end
  end

  def render_404
    render file: "#{Rails.root}/public/404", layout: false, status: :not_found
  end
end

