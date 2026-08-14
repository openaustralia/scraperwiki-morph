# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require "simplecov"
SimpleCov.start do
  skip "/spec/"
  enable_coverage :branch
  minimum_coverage 100
end

require "scraperwiki-morph"

require "webmock/rspec"
WebMock.disable_net_connect!

require "tmpdir"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # ScraperWiki memoises its configuration and database connection in module
  # instance variables. Reset them between examples so each example gets a
  # clean slate.
  config.before do
    ScraperWiki.instance_variable_set(:@config, nil)
    ScraperWiki.instance_variable_set(:@sqlite_magic_connection, nil)
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random
end
