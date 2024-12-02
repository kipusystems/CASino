require 'factory_bot'
require 'rotp'

FactoryBot.define do
  factory :two_factor_authenticator, class: 'Casino::TwoFactorAuthenticator' do
    user
    secret do
      ROTP::Base32.random
    end
    active { true }

    trait :inactive do
      active { false }
    end
  end
end
