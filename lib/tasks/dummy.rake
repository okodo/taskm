desc 'Create dummy data'
task dummy: :environment do
  unless User.exists?(email: 'init@admin.ru')
    FactoryGirl.create(:user, email: 'init@admin.ru', password: 'initialize', password_confirmation: 'initialize')
  end

  FactoryGirl.create_list(:task, 10, :with_attachment, count_attachments: 2)
end
