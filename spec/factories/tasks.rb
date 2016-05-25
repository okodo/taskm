FactoryGirl.define do
  factory :task do
    sequence(:name) {|n| "Task ##{n}" }
    description { FFaker::Lorem.sentences.join }
    user
  end
end
