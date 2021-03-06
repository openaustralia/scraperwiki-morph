require "scraperwiki-morph/version"
require "scraperwiki"

module ScraperWikiMorph
  DEFAULT_TABLE = 'data'
  DEFAULT_DATABASE = 'data.sqlite'

  def self.save_sqlite(unique_keys, data, table = DEFAULT_TABLE, verbose = 0)
    set_database
    ScraperWiki.save_sqlite(unique_keys, data, table, verbose)
  end

  def self.method_missing(method, *args)
    set_database
    ScraperWiki.send(method, *args)
  end

  def self.set_database
    ScraperWiki.config={db: DEFAULT_DATABASE}
  end
end
