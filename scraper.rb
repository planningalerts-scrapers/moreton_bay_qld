require "httparty"

url = "https://api.moretonbay.qld.gov.au/mplu/da/search/advanced"

start_date = "2021-05-01 00:00 +10:00"
end_date = "2021-05-08 00:00 +10:00"

# All application submitted in the last 28 days
end_date = Time.now
start_date = end_date - 28 * 24 * 60 * 60

query = {
  searchType: "advanced",
  propertyType: "address",
  dateRange: "custom",
  start: start_date.to_s,
  end: end_date.to_s
}

HTTParty.get(url, query: query).each do |r|
  # The API is doing the more correct thing by using a timestamp
  # that includes the timezone. In PlanningAlerts the date_received
  # doesn't include the timezone and assumes a local timezone which
  # is really not great.

  # The lodgement time in local Queensland time, then just converted
  # to a simple date (without the time bit)
  date_received = Time.parse(r["lodgedDate"]).getlocal("+10:00").to_date

  record = {
    "council_reference" => r["fileId"],
    "address" => r["primaryPropertyAddress"],
    "description" => r["description"],
    "info_url" => "https://www.moretonbay.qld.gov.au/Services/Building-Development/DA-Tracker/#{r['applicationId']}",
    "date_scraped" => Date.today.to_s,
    "date_received" => date_received.to_s
  }
  pp record
end
