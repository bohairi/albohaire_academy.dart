class CartItemModel {
  String productId;
  String title;
  String image;
  double price;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "title": title,
      "image": image,
      "price": price,
      "quantity": quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map["productId"] ?? "",
      title: map["title"] ?? "",
      image: map["image"] ?? "",
      price: (map["price"] is int)
          ? (map["price"] as int).toDouble()
          : (map["price"] ?? 0.0),
      quantity: map["quantity"] ?? 0,
    );
  }
}