require 'factory_bot'

FactoryBot.define do
  factory :login_attempt, class: 'Casino::LoginAttempt' do
    association :user, factory: :user  # Ensure FactoryBot knows which factory to use for `user`
    successful { true }
    user_ip { '133.133.133.133' }
    user_agent { 'TestBrowser' }
  end
end
