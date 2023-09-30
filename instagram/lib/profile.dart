import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store1>().name,
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
          ),
          Container(
            child: Text("팔로워 ${context.watch<Store1>().followers.toString()}명"),
          ),
          ElevatedButton(
              onPressed: () {
                context.read<Store1>().changeFollowers();
              },
              child: Text('팔로우')),
        ],
      ),
    );
  }
}
