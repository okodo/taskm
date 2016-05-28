require 'rails_helper'

feature 'User index', js: true do
  describe 'table' do
    let!(:user) { create(:user) }
    let!(:users) { create_list(:user, 4, :not_admin) }
    before { sign_in(user.email, user.password) }

    it 'should see all users' do
      visit admin_root_path
      click_link User.model_name.human(count: 2)
      expect(page).to have_css('table.table.table-striped tbody tr', visible: true, count: 5)
    end

    it 'should see all columns' do
      visit users_path
      within('table.table.table-striped thead tr') do
        %i(id email created_at).each_with_index do |a, idx|
          expect(all('th')[idx].text).to be_eql(User.human_attribute_name(a))
        end
      end
    end

    it 'destroy user' do
      visit users_path
      hide_navbar
      first("a.destroy-entry[data-uid='#{users.first.id}']").click
      expect(page).to have_css('table.table.table-striped tbody tr', visible: true, count: 4)
    end
  end
end
