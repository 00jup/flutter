import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //웹에서 정보 받아오기
// import 'package:dio/dio.dart' as dio;
import 'dart:convert';
import 'package:flutter/rendering.dart'; //스크롤 높이 측정

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
        bodyText2: TextStyle(color: Colors.black),
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
  var data;
  var sendedData = [];
  final PageController _controller = PageController(); // [1]

  Future getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200) {
      print('success');
    } else {
      throw Exception('Failed to load data');
    }
    data = json.decode(result.body);
    print(data);
    setState(() {
      sendedData = data;
    });
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
          FirstView(sendedData: sendedData),
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
  const FirstView({super.key, this.sendedData});
  final sendedData;

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

  var flag;

  Future getData() async {
    print("start\n");
    flag = "요청끝";
    print(flag);

    if (flag == "요청끝") {
      flag = "요청중";
      var url1 = 'https://codingapple1.github.io/app/more1.json';
      var url2 = 'https://codingapple1.github.io/app/more2.json';

      List<Future<http.Response>> requests = [
      http.get(Uri.parse(url1)),
      http.get(Uri.parse(url2)),
    ];

    List<http.Response> responses = await Future.wait(requests);

    for (var response in responses) {
      if (response.statusCode == 200) {
        print('success');
        var newData = json.decode(response.body);
        setState(() {
          widget.sendedData.add(newData);
        });
      } else {
        throw Exception('Failed to load data from ${response.request!.url}');
      }
    }

    }
    flag == "요청끝";
    print("end");
    print(flag);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getData();
      }
    }); //사용 다 끝나면 제거하는 것도 있음 찾아보기 ******************
    //스크롤 방향도 검사 가능하다 -> userScrollDirection
    //maxScrollExtent -> 스크롤바 최대 내릴 수 있는 높이
  }

  //유저가 밑으로 스크롤하면 하단바 숨기기

  @override
  Widget build(BuildContext context) {
    if (widget.sendedData != null) {
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          controller: _scrollController,
          itemCount: widget.sendedData?.length ?? 0,
          itemBuilder: (context, i) {
            return Column(
              children: [
                Image.network(widget.sendedData[i]['image']),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        Text(
                            "좋아요 ${widget.sendedData[i]['likes'].toString() ?? '0'}"),
                        Text(widget.sendedData[i]['content'] ??
                            'Default Content'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
