import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/material.dart';

class Notifi extends StatelessWidget {
  //Notifi({super.key, required RemoteMessage message});

  @override
  Widget build(BuildContext context) {
   // final RemoteMessage message = ModalRoute.of(context)?.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Text(message.notification!.title.toString()),
          // Text(message.notification!.body.toString()),
          // //Text(message.data.toString())
        ],
      ),
    );
  }
}
