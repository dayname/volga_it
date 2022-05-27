import 'dart:convert';
import '../utils/Links.dart';
import 'package:http/http.dart' as http;
import '../utils/quotes.dart';

class ApiProvider {
  Future<List<Quote>> getData() async {
    List<Quote> quotes = [];
    String token = "ca857riad3id34o7b08g";
    List<String> symbols = ["BINANCE:BTCUSDT", "BINANCE:ETHUSDT", "OANDA:EUR_USD", "OANDA:GBP_USD", "AAPL", "MSFT", "AMZN",];
    for (String i in symbols) {
      Link link = Link.createLink(i, token);
      Uri url = Uri.parse(link.createdLink);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Quote quote = Quote.fromJson(jsonDecode(response.body));
        quotes.add(quote);
      }
    }
    return quotes;
  }
}