import 'package:flutter/material.dart'; // 기본 위젯 쓰고 싶을 때
import 'package:cloud_firestore/cloud_firestore.dart'; // 파이어베이스 쓰고 싶을 때

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  getData() async {
    try {
      var result = await firestore.collection('product').get();
      for (var doc in result.docs) {
        print(doc['name']);
      }
    } catch (e) {
      print(e);
      print("error!!!!!");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Shop'),
    );
  }
}
