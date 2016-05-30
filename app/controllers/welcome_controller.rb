class WelcomeController < ApplicationController

  include AuthHelper

  def index
    @tasks = Task.preload(:user).order('created_at DESC').page(page_parameter).load
  end

end
