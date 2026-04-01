import 'dart:io';

import 'package:buhairi_academy_application/Screens/coach_system/coach_editCoach.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/custom_coach_list.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/model_coach.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShowCoaches extends StatefulWidget {
  const ShowCoaches({super.key});

  @override
  State<ShowCoaches> createState() => _ShowCoachesState();
}

class _ShowCoachesState extends State<ShowCoaches> {
  TextEditingController name = TextEditingController();
  TextEditingController level = TextEditingController();
  TextEditingController describe = TextEditingController();
  XFile? img;
  String? urlImage;
  final storageRef = FirebaseStorage.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Show Coaches", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Coaches").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("There is no data"));
            }
            final coaches =
                snapshot.data!.docs
                    .map((doc) => ModelCoach.fromMap(doc.data(), doc.id))
                    .toList();
            return ListView.builder(
              itemCount: coaches.length,
              itemBuilder: (context, index) {
                return CoachEditcoach(
                  modelCoach: coaches[index],
                  delete: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Delete Coach"),
                            content: Text("Are you Sure ?"),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                       Navigator.pop(context);
                                    },
                                    child: Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                       Navigator.pop(context);
                                      FirebaseFirestore.instance
                                          .collection("Coaches")
                                          .doc(coaches[index].id)
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
                            title: Text("Edit Coach"),
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
                                          ImagePicker imagePicker =
                                              ImagePicker();
                                          img = await imagePicker.pickImage(
                                            source: ImageSource.gallery,
                                          );
                                          final imageRef = storageRef.child(
                                            img!.name,
                                          );
                                          await imageRef.putFile(
                                            File(img!.path),
                                          );
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
                                          img != null
                                              ? img!.name.substring(0, 10)
                                              : "No image selected",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                customTextField("Name", name, 1),
                                customTextField("Level", level, 1),
                                customTextField("describe", describe, 4),
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      name.clear();
                                      level.clear();
                                      describe.clear();
                                    },
                                    child: Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      FirebaseFirestore.instance
                                          .collection("Coaches")
                                          .doc(coaches[index].id)
                                          .update({
                                            "urlImage": urlImage,
                                            "title": name.text,
                                            "subtitle": level.text,
                                            "describe": describe.text,
                                          });
                                      name.clear();
                                      level.clear();
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
