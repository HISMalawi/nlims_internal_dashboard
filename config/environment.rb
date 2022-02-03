# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!
Rails.application.configure do
    Rails.logger = Logger.new(STDOUT)
    config.logger = ActiveSupport::Logger.new("log/check_sync_status.log")
end
