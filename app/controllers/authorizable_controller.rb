class AuthorizableController < ApplicationController
  before_action :redirect_if_not_authorize

  private

  def redirect_if_not_authorize
    unless user_signed_in?
      redirect_to login_path
    end
  end
end

