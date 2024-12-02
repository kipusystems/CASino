require 'factory_bot'

FactoryBot.define do
  factory :proxy_granting_ticket, class: 'Casino::ProxyGrantingTicket' do
    association :granter, factory: :service_ticket
    sequence(:ticket) { |n| "PGT-ticket#{n}" }
    sequence(:iou) { |n| "PGTIOU-ticket#{n}" }
    sequence(:pgt_url) { |n| "https://www#{n}.example.org/pgtUrl" }
  end
end
