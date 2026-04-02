import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/shop_firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubscriptionMainPage extends StatelessWidget {
  final bool isAnnual;

  const SubscriptionMainPage({
    super.key,
    required this.isAnnual,
  });

  Future<void> clearCart() async {
    final snapshot = await ShopFirebaseHelper.cartRef.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> increaseQuantity(Map<String, dynamic> item) async {
    final productId = item["productId"];
    final oldQuantity = item["quantity"] ?? 0;

    await ShopFirebaseHelper.cartRef.doc(productId).update({
      "quantity": oldQuantity + 1,
    });
  }

  Future<void> decreaseQuantity(Map<String, dynamic> item) async {
    final productId = item["productId"];
    final oldQuantity = item["quantity"] ?? 0;

    if (oldQuantity > 1) {
      await ShopFirebaseHelper.cartRef.doc(productId).update({
        "quantity": oldQuantity - 1,
      });
    } else {
      await ShopFirebaseHelper.cartRef.doc(productId).delete();
    }
  }

  Future<void> deleteItem(String productId) async {
    await ShopFirebaseHelper.cartRef.doc(productId).delete();
  }

  Future<void> activateSubscription() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "isSubscribed": true,
      "subscriptionType": isAnnual ? "Yearly" : "Monthly",
      "subscriptionPrice": isAnnual ? 180 : 20,
      "subscriptionStartDate": FieldValue.serverTimestamp(),
    });
  }

  Widget productListTile(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final String image = item["image"] ?? "";
    final String title = item["title"] ?? "";
    final int quantity = item["quantity"] ?? 0;

    final double price = (item["price"] is int)
        ? (item["price"] as int).toDouble()
        : (item["price"] ?? 0.0);

    final double subTotal = price * quantity;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: MediaQuery.of(context).size.width * 0.2,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 70,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "JOD ${price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Subtotal: JOD ${subTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => increaseQuantity(item),
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                ),
                Text(
                  "$quantity",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () => decreaseQuantity(item),
                  icon: const Icon(Icons.remove_circle, color: Colors.orange),
                ),
              ],
            ),
            IconButton(
              onPressed: () => deleteItem(item["productId"]),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void showPaymentDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Payment"),
          content: Text(
            "Plan: ${isAnnual ? "Yearly" : "Monthly"}\n"
            "Total amount: JOD ${total.toStringAsFixed(2)}\n\n"
            "Do you want to continue?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await activateSubscription();
                  await clearCart();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${isAnnual ? "Yearly" : "Monthly"} subscription activated successfully",
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error while activating subscription: $e"),
                      ),
                    );
                  }
                }
              },
              child: const Text("Pay Now"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAnnual ? "Yearly Subscription" : "Monthly Subscription",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: ShopFirebaseHelper.cartRef
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.hourglass_empty,
                      size: 120,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Add products before confirming your subscription",
                      style: TextStyle(color: Colors.grey.shade700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            final cartItems = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isAnnual ? "Yearly Plan" : "Monthly Plan",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      StreamBuilder<double>(
                        stream: ShopFirebaseHelper.getTotalBill(),
                        builder: (context, totalSnapshot) {
                          final total = totalSnapshot.data ?? 0.0;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "JOD ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                total.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      const Icon(
                        Icons.shopping_cart,
                        size: 45,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return productListTile(context, cartItems[index]);
                    },
                  ),
                ),
                StreamBuilder<double>(
                  stream: ShopFirebaseHelper.getTotalBill(),
                  builder: (context, totalSnapshot) {
                    final total = totalSnapshot.data ?? 0.0;

                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: total <= 0
                            ? null
                            : () => showPaymentDialog(context, total),
                        child: Text(
                          "Pay Now - ${isAnnual ? "Yearly" : "Monthly"}",
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text("Payment is supported via :"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.credit_card, size: 30, color: Colors.grey),
                    const SizedBox(width: 15),
                    Text(
                      "Zain Cash / Umniah Coin / Visa",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}