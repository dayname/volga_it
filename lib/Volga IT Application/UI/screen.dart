import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/api_events.dart';
import '../Bloc/api_bloc.dart';
import '../Bloc/api_state.dart';
import '../utils/quotes.dart';

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

      home: BlocProvider(
        create: (BuildContext context) => ApiBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Timer timer;
  int counter = 0;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) {context.read<ApiBloc>().add(GetQuotesEvent());
    setState(() {});});
  }
  List<String> companyNames = ["BTC/USDT", "ETH/USDT", "EUR/USD", "GBP/USD", "AAPL", "MSFT", "AMZN"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Quotes',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: buildBloc(),
    );
  }

  Widget buildBloc() {
    return BlocBuilder<ApiBloc, ApiState>(builder: (context, state) {
      if (state is InitialState) {
        context.read<ApiBloc>().add(GetQuotesEvent());
      }
      if (state is FailureState) {
        return const Center(child: Text("Error"));
      } else if (state is SuccessQuotesList) {
        return QuotesList(state.quotes);
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }


  Widget QuotesList(List<Quote> quotes) {
    return Padding(
        padding: const EdgeInsets.only(top: 6),
        child:
            // RefreshIndicator(
            // onRefresh: () {
            //   return Future.delayed(const Duration(seconds: 4), () {});
            // },
            // child:
            // RefreshIndicator(
            //   onRefresh: () async{
            //     buildBloc();
            //   return Future.value();
            // }, child:
            ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (BuildContext context, int index) {
              return
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: (quotes[index].change >= 0) ? const Icon(Icons.keyboard_arrow_up, color: Colors.green, size: 40,) : const Icon(Icons.keyboard_arrow_down, color: Colors.red, size: 40,),
                        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(companyNames[index],  style: const TextStyle(fontSize: 20)),
                            Text("${quotes[index].current} ", style: const TextStyle(fontSize: 20)),

                          ],
                        ),
                        subtitle: (quotes[index].change >= 0) ? Row(
                          children: [
                            Text("${quotes[index].percentChange.toStringAsFixed(2)}%", style: const TextStyle(fontSize: 20, color: Colors.green)),
                            Text("  (${quotes[index].change.toStringAsFixed(2)})", style: const TextStyle(fontSize: 16        , color: Colors.green)),
                          ],
                        ) : Row(
                          children: [
                            Text("${quotes[index].percentChange.toStringAsFixed(2)}%", style: const TextStyle(fontSize: 20, color: Colors.red)),
                            Text("  (${quotes[index].change.toStringAsFixed(2)})", style: const TextStyle(fontSize: 16         , color: Colors.red)),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                );
            }),
        );

  }
}
