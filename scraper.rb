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

pp HTTParty.get(url, query: query)
