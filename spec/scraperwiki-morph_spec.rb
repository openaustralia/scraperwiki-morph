require 'spec_helper'

describe ScraperWikiMorph do
  describe ".save_sqlite" do
    it "should use the data table by default" do
      unique_keys, data = double, double
      ScraperWiki.should_receive(:save_sqlite).with(unique_keys, data, "data", 0)
      ScraperWikiMorph.save_sqlite(unique_keys, data)
    end

    it "should use whatever table you want" do
      unique_keys, data, table = double, double, double
      ScraperWiki.should_receive(:save_sqlite).with(unique_keys, data, table, 0)
      ScraperWikiMorph.save_sqlite(unique_keys, data, table)
    end

    it "should support the verbose parameter" do
      unique_keys, data, table, verbose = double, double, double, double
      ScraperWiki.should_receive(:save_sqlite).with(unique_keys, data, table, verbose)
      ScraperWikiMorph.save_sqlite(unique_keys, data, table, verbose)
    end
  end
end
