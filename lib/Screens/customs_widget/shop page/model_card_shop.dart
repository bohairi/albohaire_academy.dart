class ModelCardShop {
  String? id;
  String urlImage;
  String title;
  double price;
  String describe;
  List<String> images;

  ModelCardShop({
    this.id,
    required this.urlImage,
    required this.title,
    required this.price,
    required this.describe,
    required this.images,
  });

  ModelCardShop copyWith({
    String? id,
    String? urlImage,
    String? title,
    double? price,
    String? describe,
    List<String>? images,
  }) {
    return ModelCardShop(
      id: id ?? this.id,
      urlImage: urlImage ?? this.urlImage,
      title: title ?? this.title,
      price: price ?? this.price,
      describe: describe ?? this.describe,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "image": urlImage,
      "name": title,
      "price": price,
      "describe": describe,
      "images": images,
    };
  }

  factory ModelCardShop.fromMap(Map<String, dynamic> map, String cardId) {
    return ModelCardShop(
      id: cardId,
      urlImage: map["image"] ?? "",
      title: map["name"] ?? "",
      price: (map["price"] is int)
          ? (map["price"] as int).toDouble()
          : (map["price"] ?? 0.0),
      describe: map["describe"] ?? "",
      images: List<String>.from(map["images"] ?? []),
    );
  }
}