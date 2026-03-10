import 'package:buhairi_academy_application/Screens/coach_system/show_products.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoachFirstpage extends StatefulWidget {
  CoachFirstpage({super.key});

  @override
  State<CoachFirstpage> createState() => _CoachFirstpageState();
}

class _CoachFirstpageState extends State<CoachFirstpage> {
  TextEditingController image = TextEditingController();

  TextEditingController title = TextEditingController();

  TextEditingController price = TextEditingController();

  TextEditingController describe = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("add products",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout,color: Colors.white,),
          ),
        ],
      ),
      body: Container(
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
        child: Column(children: [
          customTextField(image, "image"),
          customTextField(title, "name of product"),
          customTextField(price, "price"),
          customTextField(describe, "describe the product"),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: ()async{
            ModelCardShop newProduct =  ModelCardShop(id: "", urlImage: image.text, title: title.text, price: double.parse(price.text), describe: describe.text);
            setState(() {
              isLoading = true;
            });
            await addProduct(newProduct);
            setState(() {
              isLoading = false;
            });
            image.clear();
            title.clear();
            price.clear();
            describe.clear();
          }, child: isLoading ?  CircularProgressIndicator() : Center(child: Text("Add Product",style: TextStyle(color: Colors.white),)) ,style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12)
            )
          )),
          SizedBox(height: 5,),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowProducts()));
          },style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12)
            )
          ), child: Center(child: Text("Show Products",style: TextStyle(color: Colors.white),)))
        ],
       ),
      ),
    );
  }

  Widget customTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
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

  Future<void> addProduct(ModelCardShop product) async{
    final docRef = FirebaseFirestore.instance.collection("products").doc();
    product = product.copyWith(id: docRef.id);
    await docRef.set(product.toMap());
  }
}
