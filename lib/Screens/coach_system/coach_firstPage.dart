import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoachFirstpage extends StatelessWidget {
  const CoachFirstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Center(child: Column(
          children: [
            Text("Coach Page", style: TextStyle(fontSize: 40),),
            ElevatedButton(onPressed: (){
              FirebaseAuth.instance.signOut();
            }, child: Text("sign out"))
          ],
        ),),
      ),
    );
  }
}