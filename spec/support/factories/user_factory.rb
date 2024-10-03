require 'factory_bot'

FactoryBot.define do
  factory :user, class: 'Casino::User' do
    authenticator { 'test' }
    sequence(:username) { |n| "test#{n}" }

    # Assuming fullname, age, and roles are attributes of Casino::User
    fullname { "Test User" }
    age { 15 }
    roles { [:user] }  # This should be an array if roles are stored that way
  end
end
