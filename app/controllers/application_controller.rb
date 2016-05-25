class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: ->(e) { rescue_catcher(e, I18n.t('wrong_url'), 404) }
  rescue_from CanCan::AccessDenied, with: ->(e) { rescue_catcher(e, I18n.t('auth.errors.no_permissions'), 401) }

  before_action :signin_remembered_user
  before_action :load_current_user

  attr_reader :current_user

  helper_method :current_user, :user_signed_in?

  def load_current_user
    if session[:uid].present?
      @current_user = User.find_by_id(session[:uid])
      session[:uid] = @current_user&.id
    else
      @current_user = nil
    end
  end

  def signin_remembered_user
    return if session[:uid].present? || cookies[:taskm_authtoken].blank?
    @current_user = User.find_by(remember_token: cookies[:taskm_authtoken])
    if @current_user.blank? || @current_user.remember_expired?
      session[:uid] = nil
      @current_user = nil
    else
      session[:uid] = @current_user&.id
    end
  end

  def user_signed_in?
    @current_user.present?
  end

  protected


  def ajax_request?
    request.format.to_s =~ /json|javascript/ || request.xhr?
  end

  def require_authentication
    unless user_signed_in?
      session[:return_to] = request.fullpath
      if ajax_request?
        render json: { message: I18n.t('auth.errors.no_permissions') }, status: 403 and return
      else
        redirect_to new_session_path and return
      end
    end
  end

  def require_no_authentication
    if user_signed_in?
      flash[:alert] = I18n.t('auth.errors.already_signed_in')
      redirect_to session[:return_to].present? ? session[:return_to] : admin_root_path
    end
  end

  private

  def page_parameter(param_name = :page)
    params[param_name].to_i > 0 ? params[param_name].to_i : 1
  end

  # :nocov:
  def rescue_catcher(exception, message, status_code = 404, redirect_url = root_path)
    if Rails.env.development?
      raise exception
    elsif ajax_request?
      render json: { message: message }, status: status_code and return
    else
      redirect_to redirect_url, alert: message and return
    end
  end
  # :nocov:

end
