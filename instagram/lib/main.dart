import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      appBarTheme: AppBarTheme(
          color: Colors.white,
          actionsIconTheme: IconThemeData(color: Colors.black, size: 50)),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.red),
      ),
    ),
    home: const MyApp(),
  ));
}

TextStyle a =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  final PageController _controller = PageController(); // [1]

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var data = json.decode(result.body);
    print(data[0]);
  }

  @override //MyApp 위젯이 로드될 때 실행되는 함수
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "instagram",
          style: a,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add_box_outlined))
        ],
      ),
      body: PageView(
        controller: _controller, // [2]
        onPageChanged: (i) {
          setState(() {
            tab = i;
          });
        },
        children: [
          FirstView(),
          Container(
            color: Colors.blue,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab, // [3]
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
            _controller.animateToPage(i, // [4]
                duration: Duration(milliseconds: 10),
                curve: Curves.easeInOut);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: "shopping"),
        ],
      ),
    );
  }
}

class FirstView extends StatefulWidget {
  const FirstView({super.key});

  @override
  State<FirstView> createState() => _FirstViewState();
}

// void _incrementLikes(int i) {
//   setState((i) {
//     images[i].likes++;
//   });
// }

class _FirstViewState extends State<FirstView> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        controller: _scrollController,
        itemCount: 10,
        itemBuilder: (context, i) {
          return Column(
            children: [
              Image(image: AssetImage("assets/latte.png")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () {},
                    )
                  ],
                ),
              )
            ],
          );
        });
  }
}
