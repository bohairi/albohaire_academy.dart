import 'dart:io';

import 'package:buhairi_academy_application/Screens/coach_system/custom_editPost.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/achievements/custom_achiev_card.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/achievements/model_achievement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShowAchievements extends StatefulWidget {
  const ShowAchievements({super.key});

  @override
  State<ShowAchievements> createState() => _ShowAchievementsState();
}

class _ShowAchievementsState extends State<ShowAchievements> {
  XFile? img;
  String? urlImage;
  String nameImage ="";
  final storageRef = FirebaseStorage.instance.ref();
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController describe = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameImage = img != null ? img!.name.substring(0, 10) : "No image selected";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Show Achievements", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("achievements").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("There is no Data"));
          }
          final Posts =
              snapshot.data!.docs
                  .map((doc) => ModelAchievement.fromMap(doc.data(), doc.id))
                  .toList();
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: Posts.length,
            itemBuilder: (context, index) {
              return CustomEditpost(
                modelAchievement: Posts[index],
                delete: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete Post"),
                          content: Text("Are you Sure ?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("CANCEL"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    FirebaseFirestore.instance
                                        .collection("achievements")
                                        .doc(Posts[index].id)
                                        .delete();
                                  },
                                  child: Text("YES"),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
                edit: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Edit Post"),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        img = await imagePicker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        final imageRef = storageRef.child(
                                          img!.name,
                                        );
                                        await imageRef.putFile(File(img!.path));
                                        urlImage =
                                            await imageRef.getDownloadURL();
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: BoxBorder.all(),
                                    ),

                                    child: Center(
                                      child: Text(
                                        nameImage,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              customTextField("Title", title, 1),
                              customTextField("Subtitle", subtitle, 1),
                              customTextField("describe", describe, 4),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    nameImage = "No image selected";
                                    title.clear();
                                    subtitle.clear();
                                    describe.clear();
                                  },
                                  child: Text("CANCEL"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    FirebaseFirestore.instance
                                        .collection("achievements")
                                        .doc(Posts[index].id)
                                        .update({
                                          "urlImage": urlImage,
                                          "title": title.text,
                                          "subtitle": subtitle.text,
                                          "describe": describe.text,
                                        });
                                        nameImage = "No image selected";
                                    title.clear();
                                    subtitle.clear();
                                    describe.clear();
                                  },
                                  child: Text("Edit"),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget customTextField(
    String label,
    TextEditingController controller,
    int maxlines,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLines: maxlines,
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
