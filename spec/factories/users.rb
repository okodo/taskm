FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@factory.com" }

    password 'Pa55w0rd!'
    password_confirmation 'Pa55w0rd!'

    trait :not_admin do
      role :user
    end
  end
end
