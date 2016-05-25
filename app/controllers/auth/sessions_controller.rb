class Auth::SessionsController < ApplicationController

  before_action :require_authentication, only: :destroy
  before_action :require_no_authentication, only: %i(new create)

  def new
    @user = User.new
    @user.password = @user.password_confirmation = nil
  end

  def create
    @user = User.find_by(email: params[:user].try(:[], :email)&.downcase)
    if @user.present? && @user.valid_password?(params[:user].try(:[], :password))
      session[:uid] = @user.id
      if params[:remember_me].present?
        @user.remember_me
        cookies[:taskm_authtoken] = { value: @user.remember_token, expires: (@user.remember_created_at + 2.weeks) }
      end
      redirect_to session[:return_to].present? ? session[:return_to] : admin_root_path
    else
      flash[:alert] = I18n.t("auth.errors.#{@user.blank? ? 'email_doesnt_exist' : 'invalid_password'}")
      redirect_to new_session_path
    end
  end

  def destroy
    cookies[:taskm_authtoken] = nil
    reset_session
    redirect_to root_path
  end

end
