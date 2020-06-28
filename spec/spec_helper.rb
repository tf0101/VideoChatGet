require "bundler/setup"
require "video_chat_get"
require "site_list/openrec_analyze"
require "site_list/mildom_analyze"
require "site_list/fuwatch_analyze"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
