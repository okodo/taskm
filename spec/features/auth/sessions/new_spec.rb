require 'rails_helper'

feature 'Sing In', js: true do
  context 'errors' do
    it 'submit empty form' do
      visit new_session_path
      click_button I18n.t('auth.sessions.new.form.submit')
      expect(page).not_to have_css('div.bootstrap-growl.alert.alert-danger', visible: true, count: 1, text: I18n.t('auth.errors.email_doesnt_exist'))
    end

    it 'wrong login data' do
      visit new_session_path
      within('form#auth-form') do
        fill_in 'user_email', with: 'wrong@admin.ru'
        fill_in 'user_password', with: 'wrong password'
      end
      click_button I18n.t('auth.sessions.new.form.submit')
      expect_growl_alert(I18n.t('auth.errors.email_doesnt_exist'))
    end
  end

  context 'should authorized user' do
    let!(:user) { create(:user) }

    it 'success' do
      sign_in(user.email, user.password)
      expect(current_path).to be_eql(admin_root_path)
    end
  end
end
