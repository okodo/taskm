class WelcomeController < ApplicationController

  def index
    @tasks = Task.order('created_at DESC').page(page_parameter).load
  end

end
