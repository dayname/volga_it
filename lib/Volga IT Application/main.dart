
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Company.dart';
import 'Links.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blueGrey,

          )
      ),

      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    collectData();
  }
  List <Company> companies = [];
  List<String> companyNames = ["BTC/USDT", "ETH/USDT", "EUR/USD", "GBP/USD", "AAPL", "MSFT", "AMZN"];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Finnhub App',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: createListView(),
    );
  }


 Widget createListView() {
    return
      RefreshIndicator(
        onRefresh: () async{
          companies=[];
          await collectData();
          setState(() {});
          return Future.value();
        }, child: ListView.builder(
          itemCount: companies.length,
          itemBuilder: (BuildContext context, int index) {
            return
              Column(
                children: [
                  ListTile(
                    leading: (companies[index].change >= 0) ? Icon(Icons.keyboard_arrow_up, color: Colors.green, size: 40,) : Icon(Icons.keyboard_arrow_down, color: Colors.red, size: 40,),
                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(companyNames[index],  style: const TextStyle(fontSize: 20)),
                        Text("${companies[index].current} ", style: const TextStyle(fontSize: 20)),

                      ],
                    ),
                    subtitle: (companies[index].change >= 0) ? Row(
                      children: [
                        Text("${companies[index].percentChange}%", style: const TextStyle(fontSize: 20, color: Colors.green)),
                        Text("  (${companies[index].change})", style: const TextStyle(fontSize: 16        , color: Colors.green)),
                      ],
                    ) : Row(
                      children: [
                        Text("${companies[index].percentChange}%", style: const TextStyle(fontSize: 20, color: Colors.red)),
                        Text("  (${companies[index].change})", style: const TextStyle(fontSize: 16         , color: Colors.red)),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
          }),
      );
  }


  collectData() async{
    String token = "c91f87qad3i84i3i99c0";
    List<String> symbols = ["BINANCE:BTCUSDT", "BINANCE:ETHUSDT", "OANDA:EUR_USD","OANDA:GBP_USD", "AAPL", "MSFT", "AMZN"];
    for (String i in symbols)  {
      Link link = Link.createLink(i, token);
      Uri url = Uri.parse(link.createdLink);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Company company = Company.fromJson(jsonDecode(response.body));
        companies.add(company);
        setState(() {});
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error ${response.reasonPhrase}')));
      }
    }
  }
}
