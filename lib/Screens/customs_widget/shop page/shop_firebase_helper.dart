import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopFirebaseHelper {
  static String get uid => FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference<Map<String, dynamic>> get favRef =>
      FirebaseFirestore.instance.collection("users").doc(uid).collection("isFav");

  static CollectionReference<Map<String, dynamic>> get cartRef =>
      FirebaseFirestore.instance.collection("users").doc(uid).collection("cart");

  static Future<void> toggleFavorite(ModelCardShop product) async {
    final docRef = favRef.doc(product.id);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set(product.toMap());
    }
  }

  static Stream<bool> isFavoriteStream(String productId) {
    return favRef.doc(productId).snapshots().map((doc) => doc.exists);
  }

  static Future<void> addToCart(ModelCardShop product) async {
    final docRef = cartRef.doc(product.id);
    final doc = await docRef.get();

    if (doc.exists) {
      final oldQuantity = doc.data()?["quantity"] ?? 0;
      await docRef.update({
        "quantity": oldQuantity + 1,
      });
    } else {
      await docRef.set({
        "productId": product.id,
        "title": product.title,
        "image": product.urlImage,
        "price": product.price,
        "quantity": 1,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> removeOneFromCart(ModelCardShop product) async {
    final docRef = cartRef.doc(product.id);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final oldQuantity = doc.data()?["quantity"] ?? 0;

    if (oldQuantity > 1) {
      await docRef.update({
        "quantity": oldQuantity - 1,
      });
    } else {
      await docRef.delete();
    }
  }

  static Stream<int> getProductQuantity(String productId) {
    return cartRef.doc(productId).snapshots().map((doc) {
      if (!doc.exists) return 0;
      return doc.data()?["quantity"] ?? 0;
    });
  }

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