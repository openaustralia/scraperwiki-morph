require "scraperwiki-morph/version"
require "scraperwiki"

module ScraperWikiMorph
  def self.save_sqlite(unique_keys, data, table = "data")
    ScraperWiki.save_sqlite(unique_keys, data, table)
  end
end
