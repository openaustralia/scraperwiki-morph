require 'spec_helper'

describe ScraperWikiMorph do
  describe "defaults" do
    it "uses a database called data.sqlite" do
      expect(ScraperWikiMorph::DEFAULT_DATABASE).to eq "data.sqlite"
    end

    it "uses a table called data" do
      expect(ScraperWikiMorph::DEFAULT_TABLE).to eq "data"
    end
  end

  describe ".set_database" do
    it "configures ScraperWiki to use data.sqlite" do
      expect(ScraperWiki).to receive(:config=).with({db: "data.sqlite"})
      ScraperWikiMorph.set_database
    end
  end

  describe ".save_sqlite" do
    it "should use the data table by default" do
      unique_keys, data = double, double
      expect(ScraperWiki).to receive(:config=).with({db: "data.sqlite"})
      expect(ScraperWiki).to receive(:save_sqlite).with(unique_keys, data, "data", 0)
      ScraperWikiMorph.save_sqlite(unique_keys, data)
    end

    it "should use whatever table you want" do
      unique_keys, data, table = double, double, double
      expect(ScraperWiki).to receive(:config=).with({db: "data.sqlite"})
      expect(ScraperWiki).to receive(:save_sqlite).with(unique_keys, data, table, 0)
      ScraperWikiMorph.save_sqlite(unique_keys, data, table)
    end

    it "should support the verbose parameter" do
      unique_keys, data, table, verbose = double, double, double, double
      expect(ScraperWiki).to receive(:config=).with({db: "data.sqlite"})
      expect(ScraperWiki).to receive(:save_sqlite).with(unique_keys, data, table, verbose)
      ScraperWikiMorph.save_sqlite(unique_keys, data, table, verbose)
    end
  end

  describe "delegation to ScraperWiki" do
    it "should delegate save_var to ScraperWiki" do
      expect(ScraperWiki).to receive(:config=).with({db: "data.sqlite"})
      expect(ScraperWiki).to receive(:save_var).with('current', 100)
      ScraperWikiMorph.save_var('current', 100)
    end

    it "should delegate get_var to ScraperWiki" do
      expect(ScraperWiki).to receive(:config=).with({db: "data.sqlite"})
      expect(ScraperWiki).to receive(:get_var).with('current', 0)
      ScraperWikiMorph.get_var('current', 0)
    end

    it "should delegate select to ScraperWiki" do
      expect(ScraperWiki).to receive(:config=).with({db: "data.sqlite"})
      expect(ScraperWiki).to receive(:select).with("select * from data")
      ScraperWikiMorph.select("select * from data")
    end

    it "should set the database before delegating" do
      expect(ScraperWiki).to receive(:config=).with({db: "data.sqlite"}).ordered
      expect(ScraperWiki).to receive(:sqliteexecute).ordered
      ScraperWikiMorph.sqliteexecute("select 1")
    end

    it "should raise NoMethodError for methods ScraperWiki does not have" do
      allow(ScraperWiki).to receive(:config=)
      expect { ScraperWikiMorph.not_a_real_method }.to raise_error(NoMethodError)
    end
  end

  describe "delegating scrape over stubbed HTTP" do
    it "fetches the body of a URL without touching the real network" do
      stub_request(:get, "https://example.com/").to_return(body: "<html>hello</html>")
      expect(ScraperWikiMorph.scrape("https://example.com/")).to eq "<html>hello</html>"
    end
  end

  describe "integration with a real SQLite database" do
    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          example.run
        ensure
          if ScraperWiki.instance_variable_get(:@sqlite_magic_connection)
            ScraperWiki.close_sqlite
          end
        end
      end
    end

    it "writes to a database called data.sqlite" do
      ScraperWikiMorph.save_sqlite([:id], { id: 1, name: "foo" })
      expect(File).to exist("data.sqlite")
    end

    it "round-trips rows through the data table" do
      ScraperWikiMorph.save_sqlite([:id], { id: 1, name: "foo" })
      ScraperWikiMorph.save_sqlite([:id], { id: 2, name: "bar" })
      expect(ScraperWikiMorph.select("* from data order by id")).to eq [
        { "id" => 1, "name" => "foo" },
        { "id" => 2, "name" => "bar" }
      ]
    end

    it "upserts rows that share unique keys" do
      ScraperWikiMorph.save_sqlite([:id], { id: 1, name: "foo" })
      ScraperWikiMorph.save_sqlite([:id], { id: 1, name: "baz" })
      expect(ScraperWikiMorph.select("* from data")).to eq [
        { "id" => 1, "name" => "baz" }
      ]
    end

    it "saves rows to a custom table" do
      ScraperWikiMorph.save_sqlite([:id], { id: 1 }, "other")
      expect(ScraperWikiMorph.select("* from other")).to eq [{ "id" => 1 }]
    end

    it "round-trips variables through save_var and get_var" do
      ScraperWikiMorph.save_var("last_run", "2026-08-12")
      expect(ScraperWikiMorph.get_var("last_run")).to eq "2026-08-12"
    end

    it "returns the default for an unknown variable" do
      ScraperWikiMorph.save_var("some_var", "value")
      expect(ScraperWikiMorph.get_var("unknown", "fallback")).to eq "fallback"
    end
  end
end
