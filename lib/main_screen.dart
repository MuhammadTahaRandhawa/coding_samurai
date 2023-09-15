import 'dart:async';
import 'dart:convert';

import 'package:coding_samurai_project1/qoute_,model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

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

  var width = 500;
  var height = 1000;
  List<Quote> quotesList = [];
  Quote quote = Quote(quoteText: '', author: '');
  bool isFetching = false;
  var backgroundImage;
  List<Widget> imageList = [];

  Future<Image> fetchImage() async {

    var response =
        await http.get(Uri.parse('https://random.imagecdn.app/$width/$height'));
    var imageData = response.bodyBytes;
    var newBackgroundImage = Image.memory(imageData);

    width = MediaQuery.of(context).size.width.ceil();
    height = MediaQuery.of(context).size.height.ceil();
    return newBackgroundImage;


  }

  void fetchQuote() async {
    setState(() {
      isFetching = true;
    });
     backgroundImage =  await fetchImage();
      imageList.add(backgroundImage);

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
    if (quotesList.last == quote && imageList.last == backgroundImage) {
      return;
    } else {
      var index = quotesList.indexOf(quote);
      var indexImage = imageList.indexOf(backgroundImage!);
      setState(() {
        quote = quotesList[index + 1];
        backgroundImage = imageList[indexImage + 1];
      });
    }
  }

  void previousQuote() {
    if (quotesList.first == quote && imageList.first == backgroundImage) {
      return;
    } else {
      var index = quotesList.indexOf(quote);
      var indexImage = imageList.indexOf(backgroundImage!);
      setState(() {
        quote = quotesList[index - 1];
        backgroundImage = imageList[indexImage - 1];
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
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          color: Colors.black54,
                          child: Text("\"${quote.quoteText}\"",
                              style: GoogleFonts.esteban(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(quote.author,
                            style: GoogleFonts.esteban(
                                fontSize: 20,
                                color: Colors.white,
                                backgroundColor: Colors.black54),
                            textAlign: TextAlign.center),
                      ],
                    ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    color: Colors.black54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: previousQuote,
                            icon: const Icon(Icons.arrow_back_outlined)),
                        IconButton(
                            onPressed: fetchQuote,
                            icon: const Icon(Icons.refresh)),
                        IconButton(
                            onPressed: nextQuote,
                            icon: const Icon(Icons.arrow_forward_outlined)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
    return Scaffold(
      body: isFetching == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              backgroundImage ??
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              Positioned(child: body)
            ]),
    );
  }
}
