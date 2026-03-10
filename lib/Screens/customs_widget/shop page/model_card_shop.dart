import 'package:flutter/material.dart';

class ModelCardShop {
  String? id;
  String urlImage;
  String title;
  double price;
  bool isfavorite;
  // int quantity;
  String describe;
  // List <String> images;
  ModelCardShop({this.id,required this.urlImage,required this.title,required this.price ,this.isfavorite = false,required this.describe});

  ModelCardShop copyWith({
  String? id,
  String? urlImage,
  String? title,
  double? price,
  bool? isfavorite,
  String? describe,
  }){
    return ModelCardShop(id: id?? this.id,urlImage: urlImage ?? this.urlImage, title: title ?? this.title, price: price ?? this.price,isfavorite: isfavorite?? this.isfavorite, describe: describe ?? this.describe);
  }

//toMap
Map<String,dynamic> toMap(){
  return {
    "id" : id,
    "image" : urlImage,
    "name" : title,
    "price" : price,
    "describe" : describe,
    "isfavorite" : isfavorite
  };
}

//fromMap
factory ModelCardShop.fromMap(Map<String,dynamic> map, String cardId){
  return ModelCardShop(id: cardId,urlImage: map["urlImage"]?? "", title: map["name"] ?? "", price: map["price"], describe: map["describe"]?? "");
}
}


// List<ModelCardShop> myCart = [];

// double getTotalBill() {
//   return myCart.fold(0, (sum, item) => sum + item.price);
// }

// List <ModelCardShop> cards = [
//   ModelCardShop(urlImage: "assets/images/belts.jpeg", title: "All Belts", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/belts.jpeg",
//     "assets/images/belts.jpeg",
//     "assets/images/belts.jpeg",
//   ]),
//   ModelCardShop(urlImage: "assets/images/teakwondo-boy.png", title: "Teakwondo Suit", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways.", images: [
//     "assets/images/teakwondo-boy.png",
//     "assets/images/teakwondo-boy.png",
//     "assets/images/teakwondo-boy.png",
//   ]),
//   ModelCardShop(urlImage: "assets/images/teakwondo.png", title: "Protectors", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/teakwondo.png",
//     "assets/images/teakwondo.png",
//     "assets/images/teakwondo.png",
//   ]),
//   ModelCardShop(urlImage: "assets/images/logo.png", title: "Black Belt", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/logo.png",
//     "assets/images/logo.png",
//     "assets/images/logo.png",
//   ]),
//    ModelCardShop(urlImage: "assets/images/belts.jpeg", title: "All Belts", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/belts.jpeg",
//     "assets/images/belts.jpeg",
//     "assets/images/belts.jpeg",
//   ]),
//   ModelCardShop(urlImage: "assets/images/teakwondo-boy.png", title: "Teakwondo Suit", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways.", images: [
//     "assets/images/teakwondo-boy.png",
//     "assets/images/teakwondo-boy.png",
//     "assets/images/teakwondo-boy.png",
//   ]),
//   ModelCardShop(urlImage: "assets/images/teakwondo.png", title: "Protectors", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/teakwondo.png",
//     "assets/images/teakwondo.png",
//     "assets/images/teakwondo.png",
//   ]),
//   ModelCardShop(urlImage: "assets/images/logo.png", title: "Black Belt", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/logo.png",
//     "assets/images/logo.png",
//     "assets/images/logo.png",
//   ]),
//    ModelCardShop(urlImage: "assets/images/belts.jpeg", title: "All Belts", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/belts.jpeg",
//     "assets/images/belts.jpeg",
//     "assets/images/belts.jpeg",
//   ]),
//   ModelCardShop(urlImage: "assets/images/teakwondo-boy.png", title: "Teakwondo Suit", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways.", images: [
//     "assets/images/teakwondo-boy.png",
//     "assets/images/teakwondo-boy.png",
//     "assets/images/teakwondo-boy.png",
//   ]),
//   ModelCardShop(urlImage: "assets/images/teakwondo.png", title: "Protectors", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/teakwondo.png",
//     "assets/images/teakwondo.png",
//     "assets/images/teakwondo.png",
//   ]),
//   ModelCardShop(urlImage: "assets/images/logo.png", title: "Black Belt", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
//     "assets/images/logo.png",
//     "assets/images/logo.png",
//     "assets/images/logo.png",
//   ]),
// ];