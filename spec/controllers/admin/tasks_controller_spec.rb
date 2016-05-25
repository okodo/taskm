require 'rails_helper'

describe Admin::TasksController do
  describe 'unauthorized' do
    it_should_behave_like 'unauthorized_resources', 'task'
  end
  context 'unauthorized custom' do
    let!(:task) { create(:task) }

    it '#start' do
      put :start, { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#finish' do
      put :finish, { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end

    it '#reopen' do
      put :reopen, { id: task.id }
      expect(response).to redirect_to(new_session_path)
    end
  end

  context 'authorized but no permissions' do
    let!(:user) { create(:user, :not_admin) }
    let!(:tasks) { create_list(:task, 5) }
    before { sign_in(user) }

    it '#index' do
      get :index
      expect(assigns(:tasks)).to be_blank
    end

    it '#show' do
      get :show, { id: tasks.first.id }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
    end

    it '#edit' do
      get :edit, { id: tasks.first.id }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
    end

    it '#update' do
      put :update, { id: tasks.first.id, task: { name: 'Task' } }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
    end

    it '#destroy' do
      delete :destroy, { id: tasks.first.id }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
    end

    it '#start' do
      put :start, { id: tasks.first.id }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
    end

    it '#finish' do
      put :finish, { id: tasks.first.id }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
    end

    it '#reopen' do
      put :reopen, { id: tasks.first.id }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
    end

    it '#create' do
      post :create, { task: { name: 'Task', user_id: tasks.first.user_id } }
      expect(Task.where(user_id: user.id).count).to be_eql(1)
    end
  end

  context '#index' do
    let!(:user) { create(:user) }
    let!(:tasks) { create_list(:task, 5) }
    before { sign_in(user) }

    it 'assign tasks' do
      get :index
      expect(assigns(:tasks).length).to be_eql(5)
    end

    it 'assign users for filter' do
      get :index
      expect(assigns(:users).length).to be_eql(6)
    end

    it 'render view' do
      get :index
      expect(subject).to render_template(:index)
    end

    it 'filter' do
      get :index, { assignee_id: user.id }
      expect(assigns(:tasks)).to be_blank
    end

    it 'pagination' do
      allow(Task).to receive(:per_page).and_return(1)
      get :index
      expect(assigns(:tasks).length).to eq(1)
    end
  end

  context '#show, #edit' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    before { sign_in(user) }

    it 'render show' do
      get :show, { id: task.id }
      expect(subject).to render_template(:show)
    end

    it 'render edit' do
      get :edit, { id: task.id }
      expect(subject).to render_template(:edit)
    end

    it 'assign users for editing' do
      get :edit, { id: task.id }
      expect(assigns(:users).length).to be_eql(2)
    end
  end

  context '#new' do
    let!(:user) { create(:user) }
    before { sign_in(user) }

    it 'render new' do
      get :new
      expect(subject).to render_template(:new)
    end

    it 'assign users for editing' do
      get :new
      expect(assigns(:users).length).to be_eql(1)
    end
  end

  context '#update' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    before { sign_in(user) }

    it 'cannot update cause validations errors' do
      put :update, { id: task.id, task: { name: nil } }
      expect(subject).to render_template(:edit)
    end

    it 'can update' do
      put :update, { id: task.id, task: { name: 'Changed' } }
      expect(task.reload.name).to be_eql('Changed')
    end
  end

  context '#create' do
    let!(:user) { create(:user) }
    before { sign_in(user) }

    it 'cannot create cause validations errors' do
      post :create, { task: { name: '' } }
      expect(subject).to render_template(:new)
    end

    it 'can create' do
      expect { post :create, { task: { name: 'Task', user_id: user.id } } }.to change { Task.count }.from(0).to(1)
    end

    it 'can create with attachment' do
      task_attrs = {
        task: {
          name: 'Task',
          user_id: user.id,
          attachments_attributes: {
            '0': {
              data_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'test_files', 'test.png'))
            }
          }
        }
      }
      expect { post :create, task_attrs }.to change { Attachment.count }.from(0).to(1)
    end
  end

  context '#destroy' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    before { sign_in(user) }

    it 'successfully destroy' do
      expect { delete :destroy, { id: task.id } }.to change { Task.count }.from(1).to(0)
    end
  end

  context '#start' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    before { sign_in(user) }

    it 'successfully started' do
      put :start, { id: task.id }
      expect(task.reload.started?).to be_truthy
    end
  end

  context '#finish' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    before { sign_in(user) }

    it 'successfully finished' do
      put :start, { id: task.id }
      put :finish, { id: task.id }
      expect(task.reload.finished?).to be_truthy
    end
  end

  context '#reopen' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    before { sign_in(user) }

    it 'successfully reopened after start' do
      put :start, { id: task.id }
      put :reopen, { id: task.id }
      expect(task.reload.new?).to be_truthy
    end

    it 'successfully reopened after finished' do
      put :start, { id: task.id }
      put :finish, { id: task.id }
      put :reopen, { id: task.id }
      expect(task.reload.new?).to be_truthy
    end
  end
end
