# Moreton Bay City Council

This is a scraper that runs on [Morph](https://morph.io). To get started [see the documentation](https://morph.io/documentation)

Add any issues to https://github.com/planningalerts-scrapers/issues/issues

## To run the scraper

    bundle exec ruby scraper.rb

### Expected output

    Storing DA/2025/1234 - 1 EXAMPLE STREET, CABOOLTURE QLD 4510
    Storing DA/2025/1235 - 2 SAMPLE ROAD, REDCLIFFE QLD 4020
    ...
    Finished - added 56 records.

Execution time under a minute

## To run the tests

    bundle exec rspec

## To run style and coding checks

    bundle exec rubocop

## To check for security updates

    gem install bundler-audit
    bundle-audit
