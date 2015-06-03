require "test_rail"

RSpec.configure do |config|
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

#Credentials used across all tests
def credentials
  { :user      => ENV['TEST_RAIL_USER'],
    :password  => ENV['TEST_RAIL_PASSWORD'],
    :namespace => ENV['TEST_RAIL_NAMESPACE'] }
end
