require 'spec_helper'

describe ScraperWikiMorph do
  it do
    unique_keys, data = double, double
    ScraperWiki.should_receive(:save_sqlite).with(unique_keys, data, "data")
    ScraperWikiMorph.save_sqlite(unique_keys, data)
  end
end
