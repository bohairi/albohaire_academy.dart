import 'package:buhairi_academy_application/Screens/coach_system/coach_add_achievements.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_firstPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoachOptions extends StatefulWidget {
  const CoachOptions({super.key});

  @override
  State<CoachOptions> createState() => _CoachOptionsState();
}

class _CoachOptionsState extends State<CoachOptions> {
  final email = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,title: Text("Welcome Coach ${nameFromEmail(email).toUpperCase()}",style: TextStyle(color: Colors.white,fontSize: 20),),centerTitle: true,
      actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout,color: Colors.white,),
          ),
        ],),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10,),
            customOption("Add Product", (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CoachFirstpage()));
            }),
            customOption("Add Achievement", (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CoachAddAchievements()));
            })
          ],
        ),
      ),
    );
  }
  String nameFromEmail(String? email){
    int index = email!.indexOf("@");
    String name = email.substring(0,index);
    return name;
  }
  Widget customOption(String nameOf, VoidCallback onPressed){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(onPressed: onPressed, child: Center(child: Text(nameOf,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        elevation: 10
      ),),
    );
  }
}