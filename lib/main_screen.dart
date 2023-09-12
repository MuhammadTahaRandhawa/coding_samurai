import 'dart:convert';

import 'package:coding_samurai_project1/qoute_,model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  List<Quote> quotesList = [];
  Quote quote = Quote(quoteText: '', author: '');
  bool isFetching = false;

  void fetchQuote() async {
    setState(() {
      isFetching = true;
    });

    var response = await http.get(Uri.parse('https://api.quotable.io/random'));
    var jsonResponse = jsonDecode(response.body);
    setState(() {
      quote = Quote(
          quoteText: jsonResponse['content'], author: jsonResponse['author']);
      isFetching = false;
    });

    quotesList.add(quote);
  }

  void nextQuote() {
    if (quotesList.last == quote) {
    } else {
      var index = quotesList.indexOf(quote);
      setState(() {
        quote = quotesList[index + 1];
      });
    }
  }

  void previousQuote() {
    if (quotesList.first == quote) {
    } else {
      var index = quotesList.indexOf(quote);
      setState(() {
        quote = quotesList[index - 1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Center(
      child: CircularProgressIndicator(strokeWidth: 10),
    );
    if (quote.quoteText != '') {
      body = Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: isFetching == true
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      //height: MediaQuery.of(context).size.height-200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Text("\"${quote.quoteText}\"",
                              style: const TextStyle(fontSize: 30),
                              textAlign: TextAlign.center),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(quote.author,
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: previousQuote,
                      icon: const Icon(Icons.arrow_back_outlined)),
                  IconButton(
                      onPressed: fetchQuote, icon: const Icon(Icons.refresh)),
                  IconButton(
                      onPressed: nextQuote,
                      icon: const Icon(Icons.arrow_forward_outlined)),
                ],
              ),
            )
          ],
        ),
      );
    }
    return Scaffold(body: body);
  }
}
