module Requests
  module AuthHelper
    def sign_in(user = double('user'))
      return if user.nil?
      request.session[:uid] = user.id
      controller.load_current_user
    end
  end
end
