module Capybara
  module SaveAndOpenScreenshot
    extend(self)

    def save_and_open_screenshot
      url = Capybara::Driver::Selenium.driver.current_url
      url = url.gsub("http://","").gsub(/:[0-9]+\//,"-").gsub(/\//,"-")
      name = "capybara-#{Time.new.strftime("%Y%m%d%H%M%S")}-#{url}.png"
      directory = "screenshots"
      FileUtils.mkdir_p directory if !File.directory?(directory)
      path = directory + "/" + name
      FileUtils.touch(path) unless File.exist?(path)
      Capybara::Driver::Selenium.driver.save_screenshot(path)
      open_in_browser(path)
    end

    def open_in_browser(path) # :nodoc
      require "launchy"
      Launchy::Browser.run(path)
    rescue LoadError
      warn "Sorry, you need to install launchy to open pages: `gem install launchy`"
    end
  end
end