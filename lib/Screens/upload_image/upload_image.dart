import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final storageRef = FirebaseStorage.instance.ref();
  String? imgUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image",style: TextStyle(color: Colors.white),),centerTitle: true,backgroundColor: Colors.blue,),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            imgUrl == null?  Container(height: 100,width: 100,color: Colors.yellow,) : Image.network(imgUrl!) ,
            ElevatedButton(onPressed: ()async{
            imgUrl = await storageRef.child("images/8d6abb4c-a115-4e38-8838-cf1748e09764250947760843102452.jpg").getDownloadURL();
            setState(() {
              
            });
            }, child: Text("Show image"))
            // final ImagePicker imagePicker =  ImagePicker();
            // final img = await imagePicker.pickImage(source: ImageSource.camera);
            // final fileRef = storageRef.child("images/${img!.name}");
            // fileRef.putFile(File(img.path));
        
            // }, child: Text("upload image"))
          ],
        ),
      ),
    );
  }
}