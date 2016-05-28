desc 'Create dummy data'
task dummy: :environment do
  FactoryGirl.create_list(:task, 10, :with_attachment, count_attachments: 2)
end
