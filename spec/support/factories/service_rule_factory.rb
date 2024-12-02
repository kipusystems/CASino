require 'factory_bot'

FactoryBot.define do
  factory :service_rule, class: 'Casino::ServiceRule' do
    sequence(:order) { |n| n }  # Generates a unique order number
    sequence(:name) { |n| "Rule #{n}" }  # Generates a unique name

    trait :regex do
      regex { true }  # Sets the regex attribute to true
    end
  end
end
