require "httparty"

url = "https://api.moretonbay.qld.gov.au/mplu/da/search/advanced?dateRange=custom&end=2021-05-08%2000%3A00%20%2B10%3A00&propertyType=address&searchType=advanced&start=2021-05-01%2000%3A00%20%2B10%3A00"

pp HTTParty.get(url)
