import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/custom_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/shop_firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  TextEditingController search = TextEditingController();

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
                  setState(() {});
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 30),
                  hintText: "Search",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("products").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("NO Product"));
                  }

                  final products = snapshot.data!.docs
                      .map((doc) => ModelCardShop.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                      .where((p) => p.title.toLowerCase().contains(search.text.toLowerCase()))
                      .toList();

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return CustomCardShop(
                        modelCardShop: products[index],
                        onFavoriteTap: () =>
                            ShopFirebaseHelper.toggleFavorite(products[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }
}