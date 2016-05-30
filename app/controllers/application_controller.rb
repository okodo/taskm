class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: ->(e) { rescue_catcher(e, I18n.t('wrong_url'), 404) }
  rescue_from CanCan::AccessDenied, with: ->(e) { rescue_catcher(e, I18n.t('auth.errors.no_permissions'), 401) }

  protected

  def ajax_request?
    request.format.to_s =~ /json|javascript/ || request.xhr?
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
