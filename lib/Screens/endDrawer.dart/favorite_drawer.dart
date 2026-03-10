import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/custom_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteDrawer extends StatelessWidget {
  FavoriteDrawer({super.key});
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("users").doc(uid).collection("isFav").snapshots(), builder: (context,snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }
      else if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
        return Center(child: Text("No Favorites"),);
      }
      final productIsFav = snapshot.data!.docs.map((doc) => ModelCardShop.fromMap(doc.data(), doc.id)).toList();

      return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: productIsFav.length, itemBuilder: (context,index){
        return CustomCardShop(modelCardShop: productIsFav[index].copyWith(isfavorite: true), onTap: (){});
      });
    });
    // List <ModelCardShop> favList = cards.where((c) => c.flagFav == true).toList();
    // return favList.isEmpty ? Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Icon(Icons.hourglass_disabled, size: 150, color: Colors.grey,),
    //       SizedBox(height: 20,),
    //       Text("There is no favorite")
    //     ],
    //   ),
    // ) : GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: favList.length, itemBuilder: (context,index){
    //     return CustomCardShop(modelCardShop: favList[index], onTap: (){},);
    //   });
  }
}