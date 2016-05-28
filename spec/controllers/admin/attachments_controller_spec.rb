require 'rails_helper'

describe Admin::AttachmentsController do
  describe 'unauthorized' do
    let!(:attachment) { create(:attachment) }

    it '#show' do
      get :show, { id: attachment.id }
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe 'authorized but no permissions' do
    let!(:user) { create(:user, :not_admin) }
    let!(:attachment) { create(:attachment) }
    before { sign_in(user) }

    it '#show' do
      get :show, { id: attachment.id }
      expect(flash[:alert]).to be_eql(I18n.t('auth.errors.no_permissions'))
    end
  end

  describe 'download' do
    let!(:user) { create(:user) }
    let!(:attachment) { create(:attachment) }
    before { sign_in(user) }

    it '#show' do
      get :show, { id: attachment.id }
      expect(controller.headers['Content-Transfer-Encoding']).to be_eql('binary')
    end
  end

  describe 'display' do
    let!(:user) { create(:user) }
    let!(:attachment) { create(:attachment, :image) }
    before { sign_in(user) }

    it '#show' do
      get :show, { id: attachment.id }
      expect(controller.headers['Content-Transfer-Encoding']).to be_eql('binary')
    end
  end
end
