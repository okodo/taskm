require 'rails_helper'

describe Auth::PasswordsController do
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

    it '#edit' do
      get :edit
      expect(response.status).to eql(302)
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.already_signed_in'))
    end

    it '#update' do
      put :update
      expect(response.status).to eql(302)
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.already_signed_in'))
    end
  end

  context '#new' do
    it 'render form' do
      get :new
      expect(subject).to render_template(:new)
    end
  end

  context '#create' do
    let!(:user) { create(:user) }

    it 'cannot send instruction cause wrong email' do
      post :create, { user: { email: 'not_existing@user.de' } }
      expect(subject).to render_template(:new)
    end

    it 'can send instruction' do
      post :create, { user: { email: user.email } }
      expect(flash[:notice]).to be_eql(I18n.t('auth.reset_password.instruction_sent'))
    end
  end

  context '#edit' do
    let!(:user) { create(:user) }

    it 'access without token' do
      get :edit
      expect(flash[:alert]).to be_eql(I18n.t('auth.reset_password.wrong_token'))
    end

    it 'render form' do
      user.password_forgotten
      get :edit, { reset_password_token: user.reset_password_token }
      expect(subject).to render_template(:edit)
    end
  end

  context '#update' do
    let!(:user) { create(:user) }

    it 'access without token' do
      put :update
      expect(flash[:alert]).to be_eql(I18n.t('auth.reset_password.wrong_token'))
    end

    it 'access with wrong token' do
      put :update, { reset_password_token: 'wrong token' }
      expect(subject).to render_template(:edit)
    end

    it 'cannot edit cause password validations - no password confirmation' do
      user.password_forgotten
      put :update, { user: { reset_password_token: user.reset_password_token, password: 'Pa55w0rd!' } }
      expect(subject).to render_template(:edit)
    end

    it 'cannot edit cause password validations - wrong password confirmation' do
      user.password_forgotten
      put :update, { user: { reset_password_token: user.reset_password_token, password: 'Pa55w0rd!', password_confirmation: 'Pa44w0rd!' } }
      expect(subject).to render_template(:edit)
    end

    it 'can edit' do
      user.password_forgotten
      put :update, { user: { reset_password_token: user.reset_password_token, password: '4siemens!', password_confirmation: '4siemens!' } }
      expect(flash[:notice]).to be_eql(I18n.t('auth.reset_password.successfully_changed'))
    end
  end
end
