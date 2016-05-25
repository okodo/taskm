FactoryGirl.define do
  factory :attachment do
    data_file { File.new(File.join(Rails.root, 'spec', 'test_files', 'test.pdf')) }
    task

    trait :image do
      data_file { File.new(File.join(Rails.root, 'spec', 'test_files', 'test.png')) }
    end
  end
end
