class ApplicationMailer < ActionMailer::Base

  default from: Rails.configuration.mailers_default_from
  layout 'postman'

end
