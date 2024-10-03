require 'factory_bot'

FactoryBot.define do
  factory :proxy_ticket, class: 'Casino::ProxyTicket' do
    association :proxy_granting_ticket
    sequence(:ticket) { |n| "PT-ticket#{n}" }
    sequence(:service) { |n| "imaps://mail#{n}.example.org/" }

    trait :consumed do
      consumed { true }
    end
  end
end
