import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopFirebaseHelper {
  static String get uid => FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference<Map<String, dynamic>> get cartRef =>
      FirebaseFirestore.instance.collection("users").doc(uid).collection("cart");

  static Stream<double> getTotalBill() {
    return cartRef.snapshots().map((snapshot) {
      double total = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final price = (data["price"] is int)
            ? (data["price"] as int).toDouble()
            : (data["price"] ?? 0.0);
        final quantity = data["quantity"] ?? 0;

        total += price * quantity;
      }

      return total;
    });
  }
}