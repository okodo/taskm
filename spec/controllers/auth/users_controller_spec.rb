require 'rails_helper'

describe Auth::UsersController do
  describe 'unauthorized' do
    it_should_behave_like 'unauthorized_resources', 'user'
  end

  describe 'authorized but no permissions' do
    it_should_behave_like 'authorized_no_perms_resources'
  end

  context '#index' do
    let!(:user) { create(:user) }
    let!(:list) { create_list(:user, 5) }
    before { sign_in(user) }

    it 'render view' do
      get :index
      expect(subject).to render_template(:index)
    end

    it 'filter' do
      get :index, { query: list.first.email }
      expect(assigns(:users)).to eq([list.first])
    end

    it 'pagination' do
      allow(User).to receive(:per_page).and_return(1)
      get :index
      expect(assigns(:users).length).to eq(1)
    end
  end

  context '#show' do
    let!(:user) { create(:user) }
    before { sign_in(user) }

    it 'render view' do
      get :show, { id: user.id }
      expect(subject).to render_template(:show)
    end
  end

  context '#new' do
    let!(:user) { create(:user) }
    before { sign_in(user) }

    it 'render view' do
      get :new
      expect(subject).to render_template(:new)
    end
  end

  context '#create' do
    let!(:user) { create(:user) }
    before { sign_in(user) }

    it 'cannot create cause validations errors' do
      post :create, { user: { email: 'user@mail.com' } }
      expect(subject).to render_template(:new)
    end

    it 'successfully created' do
      expect { post :create, { user: { email: 'user@mail.com', password: 'Pa55w0rd!', password_confirmation: 'Pa55w0rd!' } } }
        .to change { User.count }.from(1).to(2)
    end

    it 'created and notify' do
      expect { post :create, { user: { email: 'user@mail.com', password: 'Pa55w0rd!', password_confirmation: 'Pa55w0rd!' }, notify_user: 1 } }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context '#edit' do
    let!(:user) { create(:user) }
    before { sign_in(create(:user)) }

    it 'render view' do
      get :edit, { id: user.id }
      expect(subject).to render_template(:edit)
    end
  end

  context '#update' do
    let!(:user) { create(:user) }
    before { sign_in(create(:user)) }

    it 'cannot update cause validations errors' do
      put :update, { id: user.id, user: { email: 'user@mail.com', password: 'Pa55w0rd!' } }
      expect(subject).to render_template(:edit)
    end

    it 'successfully updated' do
      put :update, { id: user.id, user: { email: 'user@mail.com' } }
      expect(user.reload.email).to be_eql('user@mail.com')
    end
  end

  context '#update self' do
    let!(:user) { create(:user, :not_admin) }
    before { sign_in(user) }

    it 'cannot update cause validations errors' do
      put :update, { id: user.id, user: { email: 'user@mail.com', password: 'Pa55w0rd!' } }
      expect(subject).to render_template(:edit)
    end

    it 'successfully updated' do
      put :update, { id: user.id, user: { email: 'user@mail.com' } }
      expect(user.reload.email).to be_eql('user@mail.com')
    end
  end

  context '#destroy' do
    let!(:user) { create(:user) }
    before { sign_in(create(:user)) }

    it 'successfully destroyed' do
      expect { delete :destroy, { id: user.id } }.to change { User.count }.from(2).to(1)
    end
  end
end
