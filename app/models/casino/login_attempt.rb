class Casino::LoginAttempt < ActiveRecord::Base
  include Casino::ModelConcern::BrowserInfo

  belongs_to :user
end
