require 'rails_helper'

feature 'Tasks show', js: true do
  describe 'show' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, :with_attachment) }
    before { sign_in(user.email, user.password) }

    it 'right information' do
      visit admin_task_path(task)
      expect(page).to have_css('div.attr-title', count: 5)
      expect(page).to have_css('ul.attachments-lists', count: 1)
    end

    it 'should save changes' do
      attachment = create(:attachment, :image)
      visit admin_task_path(attachment.task)
      expect(page).to have_css('li.attachment-image', count: 1)
    end
  end
end
