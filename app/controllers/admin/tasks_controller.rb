class Admin::TasksController < ApplicationController

  before_action :require_authentication
  load_and_authorize_resource params_method: :task_params
  before_action :set_users, only: %i(index new edit)

  def index
    @tasks = @tasks.filter(params).page(page_parameter).load
  end

  def show
  end

  def new
  end

  def create
    if @task.save
      redirect_to [:admin, @task], notice: I18n.t('record_successfully.created')
    else
      set_users
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update_attributes(task_params)
      redirect_to [:admin, @task], notice: I18n.t('record_successfully.updated')
    else
      set_users
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to admin_tasks_path, notice: I18n.t('record_successfully.destroyed')
  end

  def start
    @task.start!
    render nothing: true
  end

  def finish
    @task.finish!
    render nothing: true
  end

  def reopen
    @task.reopen!
    render nothing: true
  end

  private

  def task_params
    pr = params.require(:task).permit(:name, :description, :user_id, attachments_attributes: [:data_file, :data_file_cache, :id, :_destroy])
    pr[:user_id] = current_user.id unless current_user.admin?
    pr
  end

  def set_users
    return unless current_user.admin?
    @users = User.order('email').all
  end

end
