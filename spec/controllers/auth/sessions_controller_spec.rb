require 'rails_helper'

describe Auth::SessionsController do
  context 'already authorized' do
    let!(:user) { create(:user) }
    before { sign_in(user) }

    it '#new' do
      get :new
      expect(response.status).to eql(302)
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.already_signed_in'))
    end

    it '#create' do
      post :create
      expect(response.status).to eql(302)
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.already_signed_in'))
    end
  end

  context '#new' do
    it 'render form' do
      get :new
      expect(response.status).to eql(200)
    end
  end

  context '#create' do
    let!(:user) { create(:user) }

    it 'cannot authorize cause wrong email' do
      post :create, { user: { email: 'not_existing@user.de' } }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.email_doesnt_exist'))
    end

    it 'cannot authorize cause wrong password' do
      post :create, { user: { email: user.email, password: 'wrong_password' } }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.invalid_password'))
    end

    it 'can authorized' do
      post :create, { user: { email: user.email, password: 'Pa55w0rd!' } }
      expect(session[:uid]).to be_eql(user.id)
    end

    it 'remember user' do
      post :create, { user: { email: user.email, password: 'Pa55w0rd!' }, remember_me: 1 }
      expect(cookies[:taskm_authtoken]).to be_present
      expect(cookies[:taskm_authtoken]).to be_eql(user.reload.remember_token)
    end
  end

  context 'destroy' do
    it 'already signed out' do
      get :destroy
      expect(response.status).to eql(302)
    end

    it 'success' do
      sign_in(create(:user))
      get :destroy
      expect(session[:uid]).to be_nil
    end
  end

  context 'helpers from parent controller' do
    let!(:user) { create(:user) }
    before { sign_in(user) }

    it 'current_user helper' do
      expect(controller.current_user).to be_eql(user)
    end

    it '#user_signed_in?' do
      expect(controller.user_signed_in?).to be_truthy
    end
  end

  it '#json request' do
    get :destroy, format: :json
    expect(JSON.parse(response.body).dig('message')).to be_present
  end

  context 'signin remembered user' do
    let!(:user) { create(:user) }

    it 'success' do
      user.remember_me
      cookies[:taskm_authtoken] = { value: user.remember_token, expires: (user.remember_created_at + 2.weeks) }
      controller.signin_remembered_user
      expect(controller.user_signed_in?).to be_truthy
    end

    it 'cannot cause user account is deleted' do
      user.remember_me
      cookies[:taskm_authtoken] = { value: user.remember_token, expires: (user.remember_created_at + 2.weeks) }
      user.destroy
      controller.signin_remembered_user
      expect(controller.user_signed_in?).to be_falsey
    end

    it 'cannot cause cookies expired' do
      user.remember_me
      user.update_column(:remember_created_at, 15.days.ago)
      cookies[:taskm_authtoken] = user.remember_token
      controller.signin_remembered_user
      expect(controller.user_signed_in?).to be_falsey
    end
  end
end
