class Auth::PasswordsController < ApplicationController

  before_action :require_no_authentication
  before_action :assert_reset_token_passed, only: %i(edit update)

  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by(email: params[:user].try(:[], :email)&.downcase)
    @user.errors.add(:base, I18n.t('auth.errors.email_doesnt_exist')) if @user.new_record?
    if @user.errors.any?
      render :new
    else
      @user.password_forgotten
      redirect_to new_session_path, notice: I18n.t('auth.reset_password.instruction_sent')
    end
  end

  def edit
    @user = User.new(reset_password_token: params[:reset_password_token])
  end

  def update
    @user = User.find_or_initialize_by(reset_password_token: params[:user].try(:[], :reset_password_token))
    @user.errors.add(:base, I18n.t('auth.reset_password.wrong_token')) if @user.new_record?
    @user.assign_attributes(password: params[:user].try(:[], :password), password_confirmation: params[:user].try(:[], :password_confirmation))

    if @user.valid? && @user.errors.empty?
      @user.clear_password_forgotten
      @user.save
      redirect_to new_session_path, notice: I18n.t('auth.reset_password.successfully_changed')
    else
      render :edit
    end
  end

  private

  def assert_reset_token_passed
    if params[:reset_password_token].blank? && params[:user].try(:[], :reset_password_token).blank?
      redirect_to new_session_path, alert: I18n.t('auth.reset_password.wrong_token') and return
    end
  end

end
