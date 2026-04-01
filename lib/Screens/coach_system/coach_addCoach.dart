import 'dart:io';

import 'package:buhairi_academy_application/Screens/coach_system/show_coaches.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/model_coach.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoachAddcoach extends StatefulWidget {
  const CoachAddcoach({super.key});

  @override
  State<CoachAddcoach> createState() => _CoachAddcoachState();
}

class _CoachAddcoachState extends State<CoachAddcoach> {
  TextEditingController name = TextEditingController();
  TextEditingController level = TextEditingController();
  TextEditingController describe = TextEditingController();
  XFile? img;
  String? urlImage;
  final storageRef = FirebaseStorage.instance.ref();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Coach", style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                    final imageRef = storageRef.child("coaches/${img!.name}");
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
                      img != null ? img!.name.substring(0, 10) : "No image selected",
                    ),
                  ),
                ),
              ],
            ),
            customTextField(name, "Name", 2),
            customTextField(level, "Level Dan", 2),
            customTextField(describe, "Describe", 5),
            customButton(nameOf: "Add Coach", onPressed: () async{
              ModelCoach newCoach = ModelCoach(urlImage: urlImage!, name: name.text, level: level.text, describe: describe.text);
              setState(() {
                isLoading = true;
              });
              await addCoach(newCoach);
              setState(() {
                isLoading = false;
              });
              name.clear();
              level.clear();
              describe.clear();
            }),
            customButton(nameOf: "Show Coaches", onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowCoaches()));
            })
          ],
        ),
      ),
    );
  }
  Future<void> addCoach(ModelCoach newCoach) async {
    final docRef = FirebaseFirestore.instance.collection("Coaches").doc();
    newCoach = newCoach.copyWith(id: docRef.id);
    await docRef.set(newCoach.toMap());
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
