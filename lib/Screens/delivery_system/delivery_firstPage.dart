import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeliveryFirstpage extends StatelessWidget {
  const DeliveryFirstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
          children: [
            Text("Delivery Page", style: TextStyle(fontSize: 40),),
            ElevatedButton(onPressed: (){
              FirebaseAuth.instance.signOut();
            }, child: Text("sign out"))
          ],
        ),),
    );
  }
}