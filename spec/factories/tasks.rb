FactoryGirl.define do
  factory :task do
    transient do
      count_attachments 1
    end
    sequence(:name) {|n| "Task ##{n}" }
    description { FFaker::Lorem.sentences.join }
    user

    trait :with_attachment do
      after :create do |task, evaluator|
        FactoryGirl.create_list(:attachment, evaluator.count_attachments, task_id: task.id)
      end
    end
  end
end
