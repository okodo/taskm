require 'rails_helper'

feature 'Root page', js: true do
  context 'navigation not authorized' do
    it 'sign in link' do
      visit root_path
      expect(page).to have_css('a', visible: true, count: 1, text: I18n.t('auth.signin_link'))
    end

    it 'logo' do
      visit root_path
      expect(page).to have_css('a', visible: true, count: 1, text: I18n.t('application_title'))
    end
  end

  context 'navigation authorized' do
    let!(:user) { create(:user) }
    before { sign_in(user.email, user.password) }

    it 'sign out link' do
      visit root_path
      expect(page).to have_css('#sign-out-link', visible: true, count: 1)
    end

    it 'edit profile' do
      visit root_path
      expect(page).to have_css("a[href='#{edit_user_path(user)}']", visible: true, count: 1)
    end
  end

  context 'list' do
    it 'empty' do
      visit root_path
      expect(page).to have_css('.no-items-container', visible: true, count: 1)
    end

    it 'with rights columns' do
      create_list(:task, 10)
      visit root_path
      within('table.table.table-striped thead tr') do
        %i(id created_at name email).each_with_index do |a, idx|
          expect(all('th')[idx].text).to be_eql(Task.human_attribute_name(a))
        end
      end
    end
  end
end
