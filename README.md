# ScraperWikiMorph

[![Gem Version](https://badge.fury.io/rb/scraperwiki-morph.svg)](https://badge.fury.io/rb/scraperwiki-morph)
[![CI](https://github.com/openaustralia/scraperwiki-morph/actions/workflows/ci.yml/badge.svg)](https://github.com/openaustralia/scraperwiki-morph/actions/workflows/ci.yml)

A simple compatibility layer so that you can use something that looks almost
the same as the [ScraperWiki gem](https://rubygems.org/gems/scraperwiki) - the
only real difference is that it writes to an SQLite database called
`data.sqlite` (rather than ScraperWiki's default `scraperwiki.sqlite`) and a
table called `data` (rather than ScraperWiki's default `swdata`).

This makes it very easy to transition scraper code from ScraperWiki to
[morph.io](https://morph.io).

## Requirements

Ruby 3.2 or later.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scraperwiki-morph'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install scraperwiki-morph

## Usage

Use `ScraperWikiMorph` exactly as you would use `ScraperWiki` - every method
is delegated to the [scraperwiki gem](https://rubygems.org/gems/scraperwiki),
with the database preconfigured for morph.io:

```ruby
require 'scraperwiki-morph'

# Save a record (upserted on the unique keys) to the "data" table
# in data.sqlite
ScraperWikiMorph.save_sqlite([:id], { id: 1, name: "Alice" })

# Save to a different table
ScraperWikiMorph.save_sqlite([:id], { id: 1, name: "Alice" }, "people")

# Query the data back
ScraperWikiMorph.select("* from data")
# => [{"id" => 1, "name" => "Alice"}]

# Persist scraper state between runs
ScraperWikiMorph.save_var("last_run", "2026-08-12")
ScraperWikiMorph.get_var("last_run")

# Fetch a page
html = ScraperWikiMorph.scrape("https://example.com/")
```

## Development

After checking out the repo, install dependencies and run the tests:

    $ bundle install
    $ bundle exec rspec

The test suite runs with [SimpleCov](https://github.com/simplecov-ruby/simplecov)
coverage reporting and uses [WebMock](https://github.com/bblimke/webmock) so it
never touches the network.

## Releasing a new version

Releases are published to [RubyGems.org](https://rubygems.org/gems/scraperwiki-morph)
automatically by the [Release workflow](.github/workflows/release.yml) using
[RubyGems trusted publishing](https://guides.rubygems.org/trusted-publishing/)
(OIDC) - no API keys are stored in the repository.

To release a new version:

1. Create a branch (e.g. `release/v0.2.0`) and bump the version number in
   `lib/scraperwiki-morph/version.rb` following
   [Semantic Versioning](https://semver.org)
2. Move the entries under "Unreleased" in `CHANGELOG.md` into a new section
   for the version, dated today, and update the comparison links at the bottom
3. Open a pull request and get it reviewed and merged
4. When the version bump lands on `main`, the Release workflow builds the gem,
   pushes the `vX.Y.Z` git tag and publishes to RubyGems.org

The workflow checks RubyGems.org first and skips publishing if the version
already exists, so re-runs and merges that don't change the version are safe.

### One-time trusted publishing setup (gem owners)

Publishing will fail until a gem owner performs this one-time setup:

1. On [rubygems.org](https://rubygems.org), sign in as an owner of
   `scraperwiki-morph`, go to the gem's **Settings → Trusted publishers**
   (see the [RubyGems guide](https://guides.rubygems.org/trusted-publishing/adding-a-publisher/))
   and add a **GitHub Actions** publisher with:
   - **Repository owner**: `openaustralia`
   - **Repository name**: `scraperwiki-morph`
   - **Workflow filename**: `release.yml`
   - **Environment**: `rubygems`
2. On GitHub, in this repository go to **Settings → Environments** and create
   an environment named `rubygems`. Optionally add protection rules (e.g.
   required reviewers or restricting deployments to the `main` branch) to
   control who can trigger a release.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the
[MIT License](LICENSE.txt).
