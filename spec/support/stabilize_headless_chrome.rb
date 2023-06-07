class StabilizeHeadlessChrome
  class Reaper
    MAX_SCENARIOS_PER_DRIVER = 50

    class << self

      def driver_scenario_count
        @driver_scenario_count || 0
      end

      attr_writer :driver_scenario_count

      def browser_died?
        !!@browser_died
      end

      attr_writer :browser_died

      def scenario_started
        self.browser_died = false
      end

      def scenario_ended
        return unless session.driver.is_a?(::Capybara::Selenium::Driver)

        self.driver_scenario_count += 1

        if !browser_died? && driver_scenario_count >= MAX_SCENARIOS_PER_DRIVER
          kill_session!
        end
      end

      def browser_died!
        self.browser_died = true
        kill_session!
      end

      def kill_session!
        self.driver_scenario_count = 0
        # This closes the browser
        session.quit
      end

      private

      def session
        ::Capybara.current_session
      end

    end
  end

  class CustomHttpClient < Selenium::WebDriver::Remote::Http::Default

    def initialize(open_timeout: 10, read_timeout: 60)
      super
    end

    private

    def response_for(request)
      if Reaper.browser_died?
        raise 'Waiting for session to restart'
      else
        super
      end
    rescue Net::OpenTimeout, Net::ReadTimeout
      # Chrome just died on us. We will reset the session, which causes Chrome to restart.
      # In this case, capturing a screenshot will not work for this scenario.
      warn "\n\e[31mKilling Capybara session!\e[0m\n"
      ::Reaper.browser_died!
      raise
    end
  end
end


RSpec.configure do |config|
  config.before(:each, :type => lambda {|v| v != :feature}) do
    StabilizeHeadlessChrome::Reaper.scenario_started
  end

  config.after(:each, :type => lambda {|v| v != :feature}) do
    StabilizeHeadlessChrome::Reaper.scenario_ended
  end
end
