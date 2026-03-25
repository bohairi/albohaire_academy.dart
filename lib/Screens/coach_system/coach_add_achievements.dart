import 'dart:io';

import 'package:buhairi_academy_application/Screens/coach_system/show_achievements.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/achievements/model_achievement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoachAddAchievements extends StatefulWidget {
  const CoachAddAchievements({super.key});

  @override
  State<CoachAddAchievements> createState() => _CoachAddAchievementsState();
}

class _CoachAddAchievementsState extends State<CoachAddAchievements> {
  String imageName = "";
  XFile? img;
  String? urlImage;
  final storageRef = FirebaseStorage.instance.ref();
  bool isLoading = false;
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController describe = TextEditingController();
  @override
  Widget build(BuildContext context) {
    imageName = img != null ? img!.name.substring(0, 10) : "No image selected";
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Achievement", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  img = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  final imageRef = storageRef.child(img!.name);
                  await imageRef.putFile(File(img!.path));
                  urlImage = await imageRef.getDownloadURL();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  "Upload Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                height: 40,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(),
                ),
                child: Center(
                  child: Text(
                    imageName,
                  ),
                ),
              ),
            ],
          ),
          customTextField(title, "Title", 2),
          customTextField(subtitle, "Subtitle", 2),
          customTextField(describe, "Describe", 5),
          customButton(
            nameOf: "Add Post",
            onPressed: () async {
              ModelAchievement newPost = ModelAchievement(
                urlImage: urlImage!,
                title: title.text,
                subtitle: subtitle.text,
                describe: describe.text,
              );
              setState(() {
                isLoading = true;
              });
              await addAchievements(newPost);
              setState(() {
                isLoading = false;
              });
              title.clear();
              subtitle.clear();
              describe.clear();
            },
          ),
          customButton(
            nameOf: "Show Achievements",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowAchievements()),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> addAchievements(ModelAchievement newPost) async {
    final docRef = FirebaseFirestore.instance.collection("achievements").doc();
    newPost = newPost.copyWith(id: docRef.id);
    await docRef.set(newPost.toMap());
  }

  Widget customTextField(
    TextEditingController controller,
    String hint,
    int maxlines,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        maxLines: maxlines,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  Widget customButton({
    required String nameOf,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
        child: Center(
          child:
              isLoading
                  ? CircularProgressIndicator()
                  : Text(nameOf, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
