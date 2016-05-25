class Postman < ApplicationMailer

  def password_forgotten(authenticatable)
    @authenticatable = authenticatable
    @url = edit_password_url(aid: @authenticatable.id, reset_password_token: @authenticatable.reset_password_token)
    mail(to: @authenticatable.email, subject: "[Task Manager] #{I18n.t('postman.subjects.password_forgotten')}")
  end

end
