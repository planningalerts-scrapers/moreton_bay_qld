# frozen_string_literal: true

RSpec.describe Scraper do
  # The API query embeds the current time, so freeze it to keep requests
  # identical to the recorded cassettes.
  before { Timecop.freeze(Time.parse("2026-08-11 12:00:00 +10:00")) }

  after { Timecop.return }

  describe "#scrape", :vcr do
    subject(:records) do
      [].tap do |collected|
        described_class.new.scrape { |record| collected << record }
      end
    end

    it "finds at least one development application" do
      expect(records.size).to be_positive
    end

    it "returns records with all the expected fields" do
      expect(records).to all(
        match(
          "council_reference" => match(%r{\A[A-Z]+/\d{4}/\d+}),
          "address" => match(/QLD/i),
          "description" => be_a(String),
          "info_url" => match(%r{\Ahttps://www\.moretonbay\.qld\.gov\.au/Services/Building-Development/DA-Tracker/\d+\z}),
          "date_scraped" => Date.today.to_s,
          "date_received" => match(/\A\d{4}-\d{2}-\d{2}\z/)
        )
      )
    end

    it "returns lodgement dates within the 28 day search window" do
      dates = records.map { |record| Date.parse(record["date_received"]) }
      expect(dates).to all(be_between(Date.today - 29, Date.today))
    end
  end

  describe "#run", :vcr do
    it "saves each scraped record with ScraperWiki" do
      saved = []
      allow(ScraperWiki).to receive(:save_sqlite) { |keys, record| saved << [keys, record] }

      expect { described_class.new.run }.to output(/Storing /).to_stdout

      expect(saved.size).to be_positive
      expect(saved).to all(match([["council_reference"], be_a(Hash)]))
    end
  end
end
