import 'package:buhairi_academy_application/Screens/coach_system/coach_addCoach.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_add_achievements.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_add_schaduale.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_chat_list_screen.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_firstPage.dart';
import 'package:buhairi_academy_application/Screens/coach_system/create_group_screen.dart';
import 'package:buhairi_academy_application/Screens/coach_system/group_list_screen.dart';
import 'package:buhairi_academy_application/Screens/coach_system/send_message_coach_screen.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Welcome Coach ${nameFromEmail(email).toUpperCase()}",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              customOption("Add Product", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachFirstpage()),
                );
              }),
              customOption("Add Achievement", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachAddAchievements()),
                );
              }),
              customOption("Add Coach", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachAddcoach()),
                );
              }),
              customOption("Add Schaduale", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachAddSchaduale()),
                );
              }),
              customOption("Send Message to Student", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SendMessageCoachScreen(),
                  ),
                );
              }),
              customOption("View Chats", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachChatListScreen()),
                );
              }),
              customOption("Create Group", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateGroupScreen(),
                  ),
                );
              }),
              customOption("Groups", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupListScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String nameFromEmail(String? email) {
    int index = email!.indexOf("@");
    String name = email.substring(0, index);
    return name;
  }

  Widget customOption(String nameOf, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          elevation: 10,
        ),
        child: Center(
          child: Text(
            nameOf,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
