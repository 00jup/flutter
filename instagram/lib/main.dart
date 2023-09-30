import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //웹에서 정보 받아오기
// import 'package:dio/dio.dart' as dio;
import 'dart:convert';
import 'package:flutter/rendering.dart'; //스크롤 높이 측정
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'shop.dart';
import 'profile.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:provider/provider.dart';

class Store1 extends ChangeNotifier {
  var name = 'john kim';
  int followers = 0;
  var flag = false;

  /// 클래스 안 변수는 밖에서 수정한다면 위험하다고 여겨짐. 그래서 이렇게 코딩함.
  changeFollowers() {
    if (flag == false) {
      followers++;
      flag = true;
      notifyListeners();
    } else {
      followers--;
      flag = false;
      notifyListeners();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (c) => Store1(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.blue),
        appBarTheme: AppBarTheme(
            color: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.black, size: 50)),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: const MyApp(),
    ),
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
  var userImage;
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
          IconButton(
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(
                    source: ImageSource
                        .gallery); //pickVideo //ImageSource.video //pickMultiImage도 가능함 //ImageSource.camera
                if (image != null) {
                  setState(() {
                    userImage = File(image.path);
                  });
                  Image.file(userImage);
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Upload(
                            userImage: userImage,
                            sendedData:
                                sendedData) //하나 밖에 없을 때 arrowFunction 사용하기
                        ));
              },
              icon: Icon(Icons.add_box_outlined))
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
          FirstView(userImage: userImage, sendedData: sendedData),
          Shop(),
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
  const FirstView({super.key, this.sendedData, this.userImage});
  final sendedData;
  final userImage;

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
    if (widget.sendedData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          controller: _scrollController,
          itemCount: widget.sendedData?.length ?? 0,
          itemBuilder: (context, i) {
            return Column(
              children: [
                (widget.sendedData[i]['image'].runtimeType == String)
                    ? Image.network(widget.sendedData[i]['image'])
                    : Image.file(widget.sendedData[i]['image']),
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
                        GestureDetector(
                          child: Text(
                              widget.sendedData[i]['user'] ?? 'Default User'),
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => Profile(),
                                  transitionsBuilder: (c, a1, a2, child) =>
                                      FadeTransition(opacity: a1, child: child),
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                ));
                          },
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
    }
  }
}

var inputdata1;
var inputdata2;

class Upload extends StatefulWidget {
  const Upload({super.key, this.userImage, this.sendedData});
  final userImage;
  final sendedData;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  widget.sendedData.add({
                    'image': widget.userImage,
                    'content': inputdata1,
                    'likes': inputdata2
                  });
                },
                icon: Icon(Icons.send))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(widget.userImage),
            Text('이미지업로드화면'),
            TextField(
              onChanged: (value) {
                inputdata1 = value;
              },
              decoration: InputDecoration(hintText: "내용입력"),
            ),
            TextField(
              onChanged: (value) => inputdata2 = value,
              decoration: InputDecoration(hintText: "좋아요 입력"),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)),
          ],
        ));
  }
}
