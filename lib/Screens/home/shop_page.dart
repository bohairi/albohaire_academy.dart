import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/custom_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // List <ModelCardShop> FilterdList = cards;

  // searchInEditText(String title){
  //   setState(() {
  //     if(title.isEmpty){
  //       FilterdList = cards;
  //     }
  //     else{
  //       FilterdList = cards.where((c) => c.title.toLowerCase().contains(title.toLowerCase())).toList();
  //     }
  //   });
  // }
  TextEditingController search = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Splash_Color.login_reg,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: TextField(
                    controller: search,
                    onChanged: (value) {      
                        setState(() {
                          
                        });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, size: 30),
                      hintText: "Search",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder(stream: FirebaseFirestore.instance.collection("products").snapshots(), builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center( child: CircularProgressIndicator(),);
                    }
                    else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                      return Center(child: Text("NO Product"),);
                    }
                    final products = snapshot.data!.docs.map((doc) => ModelCardShop.fromMap(doc.data(), doc.id)).where((p) => p.title.toLowerCase().contains(search.text.toLowerCase()));
                    return StreamBuilder(stream: FirebaseFirestore.instance.collection("users").doc(uid).collection("isFav").snapshots(), builder: (context,favSnapshot){
                      if(favSnapshot.connectionState == ConnectionState.waiting){
                        return Center( child: CircularProgressIndicator(),);
                      }
                      // else if(!favSnapshot.hasData || favSnapshot.data!.docs.isEmpty){
                      //   return Center( child: Text("Nothing"),);
                      // }
                      final idFav = favSnapshot.data!.docs.map((doc) => doc.id).toList();
                      final productWithFav = products.map((doc) => doc.copyWith(isfavorite: idFav.contains(doc.id))).toList();
                      return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: productWithFav.length, itemBuilder: (context,index){
                        return CustomCardShop(modelCardShop: productWithFav[index], onTap: (){
                          if(productWithFav[index].isfavorite){
                            FirebaseFirestore.instance.collection("users").doc(uid).collection("isFav").doc(productWithFav[index].id).delete();
                          }
                          else{
                            FirebaseFirestore.instance.collection("users").doc(uid).collection("isFav").doc(productWithFav[index].id).set(productWithFav[index].toMap());
                          }
                        });
                      });
                    });
                  }),
                  // child: StreamBuilder(stream: FirebaseFirestore.instance.collection("products").snapshots(), builder: (context,snapShot){
                  //   if(snapShot.connectionState == ConnectionState.waiting){
                  //     return Center(child: CircularProgressIndicator(),);
                  //   }
                  //   else if(!snapShot.hasData || snapShot.data!.docs.isEmpty){
                  //     return Center( child: Text("No Products"),);
                  //   }
                  //   final products = snapShot.data!.docs.map((doc) => ModelCardShop.fromMap(doc.data(), doc.id)).toList();
                  //   return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: products.length, itemBuilder: (context,index){
                  //     return CustomCardShop(modelCardShop: products[index], onTap: (){
                  //       addFav(products[index]);
                  //     });
                  //   });
                  // }),
                )
            // Expanded(
            //   child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: FilterdList.length, itemBuilder: (context,index){
            //     return CustomCardShop(modelCardShop: FilterdList[index], onTap: (){},);
            //   }),
            // ),
          ],
        ),
      ),
    );
    
  }
  Future<void> addFav(ModelCardShop product) async{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(uid).collection("isFav").doc(product.id).set(product.toMap());
  }
}