lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scraperwiki-morph/version'

Gem::Specification.new do |spec|
  spec.name          = "scraperwiki-morph"
  spec.version       = ScraperWikiMorph::VERSION
  spec.authors       = ["Matthew Landauer"]
  spec.email         = ["matthew@oaf.org.au"]
  spec.summary       = "ScraperWiki compatibility layer for morph.io scrapers"
  spec.description   = "A drop-in replacement for the scraperwiki gem for scrapers " \
                       "running on morph.io. It provides the same interface but saves " \
                       "data to the SQLite database (data.sqlite) and table (data) that " \
                       "morph.io expects, making it easy to move scrapers from " \
                       "ScraperWiki to morph.io."
  spec.homepage      = "https://github.com/openaustralia/scraperwiki-morph"
  spec.license       = "MIT"

  spec.metadata = {
    "source_code_uri" => "https://github.com/openaustralia/scraperwiki-morph",
    "changelog_uri" => "https://github.com/openaustralia/scraperwiki-morph/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/openaustralia/scraperwiki-morph/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "scraperwiki", "~> 3.0"
end
