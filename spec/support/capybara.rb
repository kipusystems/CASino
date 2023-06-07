Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    clear_session_storage: true,
    clear_local_storage: true,
    capabilities: [Selenium::WebDriver::Chrome::Options.new(
      args: %w[ disable-gpu no-sandbox window-size=1024,768],
    )],
    http_client: StabilizeHeadlessChrome::CustomHttpClient.new
end

# Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
Capybara.default_driver = :chrome
Capybara.javascript_driver = :chrome

Capybara.default_max_wait_time = 20
