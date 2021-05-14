require "httparty"

url = "https://api.moretonbay.qld.gov.au/mplu/da/search/advanced"

start_date = "2021-05-01 00:00 +10:00"
end_date = "2021-05-08 00:00 +10:00"

query = {
  searchType: "advanced",
  propertyType: "address",
  dateRange: "custom",
  start: start_date,
  end: end_date
}

pp HTTParty.get(url, query: query)
