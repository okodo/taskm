class Postman < ApplicationMailer

  def password_forgotten(authenticatable)
    @authenticatable = authenticatable
    @url = edit_passwords_url(reset_password_token: @authenticatable.reset_password_token)
    mail(to: @authenticatable.email, subject: "[Task Manager] #{I18n.t('postman.subjects.password_forgotten')}")
  end

  def notify_new_user(user)
    @user = user
    @url = root_url
    mail(to: user.email, subject: "[Task Manager] #{I18n.t('postman.subjects.notify_new_user')}")
  end

end
