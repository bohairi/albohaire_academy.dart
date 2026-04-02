import 'dart:io';

import 'package:buhairi_academy_application/Screens/coach_system/show_products.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoachFirstpage extends StatefulWidget {
  const CoachFirstpage({super.key});

  @override
  State<CoachFirstpage> createState() => _CoachFirstpageState();
}

class _CoachFirstpageState extends State<CoachFirstpage> {
  final storageRef = FirebaseStorage.instance.ref();

  XFile? mainImg;
  String? urlImage;

  List<XFile> extraImages = [];
  List<String> extraImageUrls = [];

  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController describe = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Add Products",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: pickMainImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Main Image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(),
                    ),
                    child: Center(
                      child: Text(
                        mainImg != null
                            ? mainImg!.name.substring(
                                0,
                                mainImg!.name.length > 12
                                    ? 12
                                    : mainImg!.name.length,
                              )
                            : "No main image",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: pickExtraImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Extra Images",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(),
                    ),
                    child: Center(
                      child: Text("${extraImages.length} selected"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              if (mainImg != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(mainImg!.path),
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 10),

              if (extraImages.isNotEmpty)
                SizedBox(
                  height: 85,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: extraImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(extraImages[index].path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    extraImages.removeAt(index);
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 10),

              customTextField(title, "Name of product", 1),
              customTextField(price, "Price", 1),
              customTextField(describe, "Describe the product", 5),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addProductFlow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Add Product",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShowProducts(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Show Products",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickMainImage() async {
    final imagePicker = ImagePicker();
    mainImg = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> pickExtraImages() async {
    final imagePicker = ImagePicker();
    final images = await imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        extraImages.addAll(images);
      });
    }
  }

  Future<String> uploadSingleImage(XFile imageFile) async {
    final imageRef = storageRef.child(
      "products/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}",
    );
    await imageRef.putFile(File(imageFile.path));
    return await imageRef.getDownloadURL();
  }

  Future<List<String>> uploadExtraImages(List<XFile> images) async {
    List<String> urls = [];
    for (XFile image in images) {
      final url = await uploadSingleImage(image);
      urls.add(url);
    }
    return urls;
  }

  Future<void> addProductFlow() async {
    if (mainImg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload main image first")),
      );
      return;
    }

    if (title.text.trim().isEmpty ||
        price.text.trim().isEmpty ||
        describe.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final parsedPrice = double.tryParse(price.text.trim());
    if (parsedPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid price")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      urlImage = await uploadSingleImage(mainImg!);
      extraImageUrls = await uploadExtraImages(extraImages);

      final List<String> allImages = [urlImage!, ...extraImageUrls];

      ModelCardShop newProduct = ModelCardShop(
        id: "",
        urlImage: urlImage!,
        title: title.text.trim(),
        price: parsedPrice,
        describe: describe.text.trim(),
        images: allImages,
      );

      await addProduct(newProduct);

      title.clear();
      price.clear();
      describe.clear();

      setState(() {
        mainImg = null;
        urlImage = null;
        extraImages = [];
        extraImageUrls = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget customTextField(
    TextEditingController controller,
    String hint,
    int maxlines,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType:
            hint == "Price" ? TextInputType.number : TextInputType.text,
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

  Future<void> addProduct(ModelCardShop product) async {
    final docRef = FirebaseFirestore.instance.collection("products").doc();
    product = product.copyWith(id: docRef.id);
    await docRef.set(product.toMap());
  }

  @override
  void dispose() {
    title.dispose();
    price.dispose();
    describe.dispose();
    super.dispose();
  }
}