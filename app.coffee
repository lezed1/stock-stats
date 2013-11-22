stocks = {}

callback = (error, json) ->
  if error
    console.warn error

  for quote in json.query.results.quote
    stocks[quote.Symbol] ?=
      name: quote.Name
      symbol: quote.Symbol
      data: []

    stocks[quote.Symbol].data.push
      name: quote.Name
      symbol: quote.Symbol
      price: quote.LastTradePriceOnly
      time: Date.parse json.query.created

  console.log _.values(stocks)

  tickers = d3.select("#data")
    .selectAll("tr")
    .data(_.values(stocks), (ticker) -> ticker.symbol)
  tickers.enter().append("tr")

  data = tickers.selectAll("td")
    .data(((ticker) -> ticker.data), (quote) -> quote.time)
    .enter().append("td")
    .text((quote) -> "Symbol: #{quote.symbol}; Price: #{quote.price}")




url = "http://query.yahooapis.com/v1/public/yql?q="
data = encodeURIComponent("select Name, Symbol, LastTradePriceOnly from yahoo.finance.quotes where symbol in (\"YHOO\",\"AAPL\",\"GOOG\",\"MSFT\")")

setInterval (-> d3.json(url + data + "&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json", callback)), 1000