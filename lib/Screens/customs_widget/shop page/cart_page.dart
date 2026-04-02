import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/shop_firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ShopFirebaseHelper.cartRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Cart is empty"));
                }

                final cartItems = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index].data() as Map<String, dynamic>;

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          item["image"],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item["title"] ?? ""),
                        subtitle: Text(
                          "JOD ${item["price"]} × ${item["quantity"]}",
                        ),
                        trailing: Text(
                          ((item["price"] ?? 0) * (item["quantity"] ?? 0))
                              .toString(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                StreamBuilder<double>(
                  stream: ShopFirebaseHelper.getTotalBill(),
                  builder: (context, snapshot) {
                    final total = snapshot.data ?? 0.0;
                    return Text(
                      "JOD ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}