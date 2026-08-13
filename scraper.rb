#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
Bundler.require

require "date"
require "time"

# Scrapes development applications lodged in the last 28 days from the
# Moreton Bay City Council DA API and saves them with ScraperWiki.
class Scraper
  API_URL = "https://api.moretonbay.qld.gov.au/mplu/da/search/advanced"
  INFO_URL_PREFIX = "https://www.moretonbay.qld.gov.au/Services/Building-Development/DA-Tracker/"
  SEARCH_WINDOW = 28 * 24 * 60 * 60

  def scrape
    applications.each do |application|
      yield record_for(application)
    end
  end

  def run
    count = 0
    scrape do |record|
      puts "Storing #{record['council_reference']} - #{record['address']}"
      ScraperWiki.save_sqlite(["council_reference"], record)
      count += 1
    end
    puts "Finished - added #{count} records."
  end

  private

  # All applications submitted in the last 28 days
  def applications
    end_date = Time.now
    start_date = end_date - SEARCH_WINDOW

    query = {
      searchType: "advanced",
      propertyType: "address",
      dateRange: "custom",
      start: start_date.to_s,
      end: end_date.to_s,
    }

    HTTParty.get(API_URL, query: query)
  end

  def record_for(application)
    {
      "council_reference" => application["fileId"],
      "address" => application["primaryPropertyAddress"],
      "description" => application["description"],
      "info_url" => "#{INFO_URL_PREFIX}#{application['applicationId']}",
      "date_scraped" => Date.today.to_s,
      "date_received" => date_received(application["lodgedDate"]).to_s,
    }
  end

  # The API is doing the more correct thing by using a timestamp that
  # includes the timezone. In PlanningAlerts the date_received doesn't
  # include the timezone and assumes a local timezone which is really
  # not great. So take the lodgement time in local Queensland time and
  # convert it to a simple date (without the time bit).
  def date_received(lodged_date)
    Time.parse(lodged_date).getlocal("+10:00").to_date
  end
end

Scraper.new.run if __FILE__ == $PROGRAM_NAME
