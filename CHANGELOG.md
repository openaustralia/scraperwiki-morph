# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Require Ruby 3.2 or later
- Bound the scraperwiki dependency to ~> 3.0

### Added

- GitHub Actions CI testing against Ruby 3.2, 3.3 and 3.4
- Automated releases to RubyGems.org via trusted publishing when a version
  bump lands on `main`
- SimpleCov coverage reporting and a much expanded spec suite
- Gem metadata: source code, changelog and bug tracker links, and
  `rubygems_mfa_required`

## [0.1.1] - 2014-01-15

### Changed

- Set the project homepage in the gemspec

## [0.1.0] - 2014-01-14

### Added

- Initial release: a compatibility layer over the
  [scraperwiki](https://rubygems.org/gems/scraperwiki) gem that saves to the
  `data.sqlite` database and `data` table expected by [morph.io](https://morph.io)

[Unreleased]: https://github.com/openaustralia/scraperwiki-morph/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/openaustralia/scraperwiki-morph/compare/v0.1...v0.1.1
[0.1.0]: https://github.com/openaustralia/scraperwiki-morph/releases/tag/v0.1
