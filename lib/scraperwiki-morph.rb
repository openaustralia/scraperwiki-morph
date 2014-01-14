require "scraperwiki-morph/version"
require "scraperwiki"

module ScraperWikiMorph
  def self.save_sqlite(unique_keys, data, table = "data", verbose = 0)
    ScraperWiki.save_sqlite(unique_keys, data, table, verbose)
  end
end
