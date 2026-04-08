import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoachManageSliderPage extends StatefulWidget {
  const CoachManageSliderPage({super.key});

  @override
  State<CoachManageSliderPage> createState() => _CoachManageSliderPageState();
}

class _CoachManageSliderPageState extends State<CoachManageSliderPage> {
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;

  final CollectionReference<Map<String, dynamic>> sliderRef =
      FirebaseFirestore.instance.collection("home_slider_images");

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() {
        isUploading = true;
      });

      File file = File(pickedFile.path);

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("home_slider_images")
          .child("$fileName.jpg");

      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      await sliderRef.add({
        "imageUrl": downloadUrl,
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  Future<void> deleteImage(String docId, String imageUrl) async {
    try {
      // حذف الصورة من Storage إذا كانت من Firebase Storage
      if (imageUrl.contains("firebasestorage")) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      // حذف الدوكيومنت من Firestore
      await sliderRef.doc(docId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image deleted successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delete failed: $e")),
        );
      }
    }
  }

  Future<void> showDeleteDialog(String docId, String imageUrl) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Image"),
        content: const Text("Are you sure you want to delete this image?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteImage(docId, imageUrl);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Slider Images"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isUploading ? null : pickAndUploadImage,
        child: isUploading
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.add_a_photo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: sliderRef.orderBy("createdAt", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  "No images yet\nTap the button below to add images",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return GridView.builder(
              itemCount: docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final data = docs[index].data();
                final String imageUrl = data["imageUrl"] ?? "";
                final String docId = docs[index].id;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: imageUrl.isEmpty
                              ? const Center(child: Text("No Image"))
                              : Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 50),
                                    );
                                  },
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Slider Image",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () => showDeleteDialog(docId, imageUrl),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}