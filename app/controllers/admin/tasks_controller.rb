class Admin::TasksController < ApplicationController

  include AuthHelper

  before_action :require_authentication
  load_and_authorize_resource params_method: :task_params
  before_action :set_users, only: %i(index new edit)
  before_filter :set_crumbs, except: %i(destroy start finish reopen)
  before_action :build_attr, only: %i(new edit)

  def index
    @tasks = @tasks.preload(:user).filter(params).page(page_parameter).load
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
      build_attr
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
      build_attr
      render :edit
    end
  end

  def destroy
    @task.destroy
    render nothing: true
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

  def build_attr
    @task.build_attachments
  end

  def task_params
    pr = params.require(:task).permit(:name, :description, :user_id, attachments_attributes: [:data_file, :data_file_cache, :id, :_destroy])
    pr[:user_id] = current_user.id unless current_user.admin?
    pr
  end

  def set_users
    return unless current_user.admin?
    @users = User.order('email').all
  end

  def set_crumbs
    add_crumb Task.model_name.human(count: 2), admin_tasks_path
    add_crumb @task.name, admin_task_path(@task) if action_name.eql?('edit')
    add_crumb @task.name if action_name.eql?('show')
    add_crumb I18n.t('crumbs.edit_item') if action_name.eql?('edit')
    add_crumb I18n.t('crumbs.new_item') if action_name.eql?('new')
  end

end
