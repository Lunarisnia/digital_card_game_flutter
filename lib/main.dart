// ignore_for_file: avoid_print

import 'dart:math';

import 'package:dio/dio.dart';
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
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    late String password;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: 250,
              child: Card(
                color: Colors.cyan.shade700,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text(
                      "Enter the password",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        onChanged: (value) => {password = value},
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (password == "lopelopetania") {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MyHomePage(title: "My Home Page"),
                          ));
                        }
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
  final String apiUrl = 'http://192.168.0.109:3000';
  Future<Map<String, dynamic>> fetchCardCount() async {
    Response response;
    final dio = Dio();
    // Optionally the request above could also be done as
    response = await dio.get('$apiUrl/card/count');
    // print(response.data.toString());
    return response.data;
  }

  // Todo: refactor this to be more clean and better looking ui wise
  Future<Map<String, dynamic>> drawCard() async {
    Response response;
    final dio = Dio();
    // Optionally the request above could also be done as
    response = await dio.get('$apiUrl/card/draw?gender=m');
    // print(response.data.toString());
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
                callback: () {
                  drawCard();
                }),
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
  const BackCardSF(
      {super.key,
      required this.cardType,
      required this.cardDesc,
      required this.callback});
  final String cardType;
  final String cardDesc;
  final Function callback;

  @override
  State<BackCardSF> createState() => _BackCardSFState();
}

class _BackCardSFState extends State<BackCardSF> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller_2;
  late Animation _animation;
  // late Animation _animation_2;
  AnimationStatus _status = AnimationStatus.dismissed;
  // AnimationStatus _status_2 = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller_2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(end: 2.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });

    // _animation_2 = Tween(end: 1.0, begin: 0.0).animate(_controller_2)
    //   ..addListener(() {
    //     setState(() {});
    //   })
    //   ..addStatusListener((status) {
    //     _status_2 = status;
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0015)
        ..rotateY(pi * _animation.value),
      // ..rotateX(pi * _animation.value)..translate(pi * _animation.value*200,pi * _animation.value*-200,2)
      // this can make a good card out animation
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
              callback: () {
                if (_status == AnimationStatus.completed) {
                  widget.callback();
                  _controller.reset();
                }
              },
            ),
      // : Transform(
      //     transform: Matrix4.identity()
      //       ..setEntry(3, 2, 0.0015)
      //       ..rotateX(pi * _animation_2.value)
      //       ..translate(pi * _animation_2.value * 200,
      //           pi * _animation_2.value * -200, 2),
      //     child: FrontCard(
      //       description: widget.cardDesc,
      //       callback: () {
      //         if (_status_2 == AnimationStatus.dismissed) {
      //           _controller_2.forward();
      //         }
      //       },
      //     ),
      //   ),
    );
  }
}

class BackCard extends StatelessWidget {
  const BackCard({super.key, required this.cardType, required this.callback});

  final String cardType;
  final Function callback;

  // Todo: Implement login page and query for male or female
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardType == 'activities'
          ? Colors.purple.shade900
          : Colors.cyan.shade900,
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
                Icon(
                    cardType == "activities"
                        ? Icons.favorite
                        : Icons.question_mark,
                    color: Colors.pink.shade100,
                    size: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://s3-ap-northeast-1.amazonaws.com/celclipcommonprod/accounts/profile-image/3d/986e82bb76b33ba93456307d0f0aae430e2a9ca43e5cb63600cfbc68b03aae08.png",
                      scale: 5,
                    ),
                    Text(
                      cardType == "activities" ? " ACTIVITIES " : " QUESTION ",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Image.network(
                      "https://s3-ap-northeast-1.amazonaws.com/celclipcommonprod/accounts/profile-image/3d/986e82bb76b33ba93456307d0f0aae430e2a9ca43e5cb63600cfbc68b03aae08.png",
                      scale: 5,
                    ),
                  ],
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
  const FrontCard(
      {super.key, required this.description, required this.callback});

  final String description;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: InkWell(
        onDoubleTap: () => callback(),
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
      ),
    );
  }
}
