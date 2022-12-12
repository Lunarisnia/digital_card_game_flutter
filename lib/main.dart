// ignore_for_file: avoid_print

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map<String, dynamic>> fetchCardCount() async {
    Response response;
    final dio = Dio();
    // Optionally the request above could also be done as
    response = await dio.get('http://192.168.0.109:3000/card/count');
    print(response.data.toString());
    return response.data;
  }

  // Todo: refactor this to be more clean and better looking ui wise
  Future<Map<String, dynamic>> drawCard() async {
    Response response;
    final dio = Dio();
    // Optionally the request above could also be done as
    response = await dio.get('http://192.168.0.109:3000/card/draw?gender=m');
    print(response.data.toString());
    displayDrawnCard(response.data);
    return response.data;
  }

  String cardDesc = "";
  String cardType = "";
  void displayDrawnCard(Map<String, dynamic> cardData) async {
    setState(() {
      cardDesc = cardData['card']['description'];
      cardType = cardData['card']['type'];
    });
  }

  @override
  void initState() {
    super.initState();
    drawCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            BackCardSF(
              cardType: cardType,
              cardDesc: cardDesc,
            ),
            // FutureBuilder(
            //   builder: (BuildContext ctx,
            //       AsyncSnapshot<Map<String, dynamic>> snapshot) {
            //     if (snapshot.hasData) {
            //       // If data do exist
            //       return Text('${snapshot.data?['count']}');
            //     } else if (snapshot.hasError) {
            //       // Data has error
            //       return const Text("Error");
            //     } else {
            //       // Currently Loading
            //       return const Text("Null");
            //     }
            //   },
            //   future: fetchCardCount(),
            // )
            // Image.network(
            //     'https://static.wikia.nocookie.net/finalfantasy/images/8/8e/White_Mage_Artwork_XIV.png/revision/latest?cb=20170723180725'),
            // const Text('The Pure Healer of the group',
            //     style: TextStyle(color: Colors.white)),
            // Text(cardDesc),
            // TextButton(onPressed: drawCard, child: const Text("GET"))
            // Text(
            //   '123123123',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
    );
  }
}

class BackCardSF extends StatefulWidget {
  const BackCardSF({super.key, required this.cardType, required this.cardDesc});
  final String cardType;
  final String cardDesc;

  @override
  State<BackCardSF> createState() => _BackCardSFState();
}

class _BackCardSFState extends State<BackCardSF> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(end: 2.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY(pi * _animation.value),
        child: _animation.value <= 0.5
            ? BackCard(
                cardType: widget.cardType,
                callback: () {
                  if (_status == AnimationStatus.dismissed) {
                    _controller.forward();
                  }
                },
              )
            : FrontCard(
                description: widget.cardDesc,
              ));
  }
}

class BackCard extends StatelessWidget {
  const BackCard({super.key, required this.cardType, required this.callback});

  final String cardType;
  final Function callback;
  // Todo: Implement proper back card with different color between activities
  // And Question

  // Todo: Implement draw new card animation
  // Todo: Implement handling if card is all out
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: InkWell(
        onTap: () => callback(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 250,
          width: MediaQuery.of(context).size.width - 50,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.favorite, color: Colors.pink.shade100, size: 200),
                Text(
                  cardType,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FrontCard extends StatelessWidget {
  const FrontCard({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 250,
        width: MediaQuery.of(context).size.width - 50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.favorite, color: Colors.pink.shade100),
              const Divider(
                color: Colors.white,
                endIndent: 30,
                indent: 30,
              ),
              SizedBox(
                // height: 150,
                width: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                endIndent: 30,
                indent: 30,
              ),
              const Text(
                "- BEDROOM COMMAND -",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}