require 'rails_helper'

feature 'Users show', js: true do
  describe 'show' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }
    let!(:other_task) { create(:task, user: task.user) }
    before { sign_in(user.email, user.password) }

    it 'right information' do
      visit user_path(task.user)
      expect(page).to have_css('div.attr-title', count: 2)
      expect(page).to have_css('table.table.table-striped tbody tr', count: 2)
    end
  end
end
