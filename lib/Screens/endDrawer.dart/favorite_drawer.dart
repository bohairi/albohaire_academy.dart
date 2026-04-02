import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/custom_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/shop_firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteDrawer extends StatelessWidget {
  const FavoriteDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ShopFirebaseHelper.favRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Favorites"));
        }

        final favoriteProducts = snapshot.data!.docs
            .map((doc) => ModelCardShop.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
          ),
          itemCount: favoriteProducts.length,
          itemBuilder: (context, index) {
            return CustomCardShop(
              modelCardShop: favoriteProducts[index],
              onFavoriteTap: () =>
                  ShopFirebaseHelper.toggleFavorite(favoriteProducts[index]),
            );
          },
        );
      },
    );
  }
}