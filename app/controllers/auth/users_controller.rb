class Auth::UsersController < ApplicationController

  before_action :require_authentication
  load_and_authorize_resource
  before_filter :set_crumbs, except: %i(destroy)

  def index
    @users = @users.filter(params).page(page_parameter).load
  end

  def show
  end

  def new
  end

  def create
    @user.assign_attributes(create_params)
    if @user.save
      Postman.notify_new_user(@user).deliver_now if params[:notify_user].present?
      redirect_to @user, notice: I18n.t('record_successfully.created')
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.assign_attributes(update_params)
    @user.skip_validate_password = 1 if params[:user].try(:[], :password).blank? && params[:user].try(:[], :password_confirmation).blank?
    if @user.save
      updated_self = self_update?
      if updated_self
        @current_ability = nil
        @current_user = nil
      end
      redirect_to (self_update? ? admin_root_path : @user), notice: I18n.t("users.successfully_updated#{updated_self ? '_self' : ''}")
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    render nothing: true
  end

  private

  def set_crumbs
    add_crumb User.model_name.human(count: 2), users_path
    add_crumb @user.id.to_s, user_path(@user) if action_name.eql?('edit')
    add_crumb @user.id.to_s if action_name.eql?('show')
    add_crumb I18n.t('crumbs.edit_item') if action_name.eql?('edit')
    add_crumb I18n.t('crumbs.new_item') if action_name.eql?('new')
  end

  def create_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def update_params
    if current_user.admin?
      create_params
    else
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end

  def self_update?
    @user.eql?(current_user)
  end

end
