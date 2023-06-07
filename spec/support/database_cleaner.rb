require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
