import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      appBarTheme:
      AppBarTheme(color: Colors.white, actionsIconTheme: IconThemeData(color: Colors.black, size: 50)),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.red),
      ),
    ),
    home: const MyApp(),
  ));
}

TextStyle a = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  final PageController _controller = PageController(); // [1]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "instagram",
          style: a,
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add_box_outlined))],
      ),
      body: PageView(
        controller: _controller, // [2]
        onPageChanged: (i) {
          setState(() {
            tab = i;
          });
        },
        children: [
          Container(
            color: Colors.red,
          ),
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
                duration: Duration(milliseconds: 3000), curve: Curves.bounceIn);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "shopping"),
        ],
      ),
    );
  }
}
