# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, GitHub Copilot,
and others) when working with code in this repository. `CLAUDE.md` and
`.github/copilot-instructions.md` point here so the guidance lives in one place.

## What this gem is

`scraperwiki-morph` is a compatibility shim. It delegates everything to the
[scraperwiki gem](https://rubygems.org/gems/scraperwiki) with the database
preconfigured the way morph.io expects (`data.sqlite`, table `data`), so scraper
code written for ScraperWiki keeps working when it moves to morph.io.

Parity with the upstream gem is the whole value, within the `scraperwiki ~> 3.0`
constraint in the gemspec: parity is with the 3.x API, so an upstream 4.0 is a
deliberate decision here rather than a routine dependency bump. Resist adding
API surface that `scraperwiki` doesn't have: a scraper that relies on something only this shim
offers is no longer portable, which defeats the purpose.

## How small it is, and why that matters

`lib/scraperwiki-morph.rb` is about twenty lines. `method_missing` forwards any
method to `ScraperWiki` after calling `set_database`, so the gem picks up the
upstream API without naming any of it. Only methods that need a morph.io
default of their own get written out explicitly, which is why `save_sqlite` is
the single one there: it supplies the `data` table default.

Two consequences:

- `respond_to_missing?` is not defined, so `ScraperWikiMorph.respond_to?(:select)`
  answers false even though calling `.select` works fine. Worth knowing before
  you write a spec or a caller that relies on `respond_to?`.
- `set_database` reassigns `ScraperWiki.config` on **every** call rather than
  once at load, because the upstream gem memoises its config and connection.

## Testing

    bundle exec rspec      # also runs as "rake spec" and the default task

Runs on Ruby 3.2, 3.3 and 3.4 in CI; `.ruby-version` pins 3.2.2 locally.

- **There is no RuboCop in this repository.** No `rubocop` gem, no
  `.rubocop.yml`, no lint job in CI. Don't run it, and don't assume a lint gate
  exists. Match the style of the file you are editing, which is not the same as
  the other OAF gems.
- `spec/spec_helper.rb` sets SimpleCov `minimum_coverage 100`. With this little
  code that is easy to break: a single new unspecced line fails the suite even
  though every example passes.
- The specs are mostly partial doubles of `ScraperWiki`, so they verify the
  delegation rather than real SQLite behaviour. `verify_partial_doubles` is on,
  which means a mocked method has to genuinely exist upstream. That is
  deliberate: it catches the `scraperwiki` gem changing a signature under us.
- The spec helper resets `ScraperWiki`'s memoised `@config` and
  `@sqlite_magic_connection` before each example. Specs touching configuration
  or the database depend on that; don't remove it.
- `WebMock.disable_net_connect!` is set, so the suite never reaches the
  network, and `config.order = :random` surfaces order dependencies. The
  "All examples were filtered out; ignoring {:focus=>true}" line at the start of
  a run is normal noise from `run_all_when_everything_filtered`, not a problem.

`Gemfile.lock` is gitignored and untracked. `bundle install` changes it
locally, which is expected. Never force-add it.

## Releasing

Don't run `bundle exec rake release`. It exists only because of
`bundler/gem_tasks` and would tag and publish from your machine. Releases are
automated: a version bump in `lib/scraperwiki-morph/version.rb` merged to
`main` publishes the gem through RubyGems trusted publishing in the `rubygems`
environment. Follow the README's "Releasing a new version" section, which also
covers why a red Release job may mean the RubyGems check couldn't get an answer
rather than that publishing failed.

## Org-level guidance

Workflow, branch naming, commit sign-off, AI disclosure and review conventions
are org-wide and deliberately not restated here. Fetch them when you need them:

    gh api repos/openaustralia/.github/contents/.github/CONTRIBUTING.md -H "Accept: application/vnd.github.raw"
    gh api repos/openaustralia/.github/contents/AGENTS.md -H "Accept: application/vnd.github.raw"

This repository has no overrides of that guidance. If one is ever agreed,
record it here with the reason, so the difference reads as a decision rather
than drift.
