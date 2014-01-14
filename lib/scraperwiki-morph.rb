require "scraperwiki-morph/version"
require "scraperwiki"

module ScraperWikiMorph
  def self.save_sqlite(unique_keys, data)
    ScraperWiki.save_sqlite(unique_keys, data, "data")
  end
end
