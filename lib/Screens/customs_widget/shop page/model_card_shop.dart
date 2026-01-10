import 'package:flutter/material.dart';

class ModelCardShop {
  String urlImage;
  String title;
  double price;
  double bill;
  int quantity;
  IconData icon;
  bool flagFav;
  String describe;
  List <String> images;
  ModelCardShop({required this.urlImage,required this.title,required this.price,required this.bill,required this.quantity, required this.icon,required this.flagFav, required this.describe, required this.images});

  ModelCardShop copyWith({
  final String? urlImage,
  final String? title,
  final double? price,
  final double? bill,
  final int? quantity ,
  final IconData? icon,
  final bool? flagFav,
  final String? describe,
  final List <String>? images,
  }){
    return ModelCardShop(urlImage: urlImage ?? this.urlImage, title: title ?? this.title, price: price ?? this.price,bill: bill ?? this.bill,quantity: quantity?? this.quantity, icon: icon ?? this.icon, flagFav: flagFav ?? this.flagFav, describe: describe ?? this.describe, images: images ?? this.images);
  }


}

List<ModelCardShop> myCart = [];

double getTotalBill() {
  return myCart.fold(0, (sum, item) => sum + item.price);
}

List <ModelCardShop> cards = [
  ModelCardShop(urlImage: "assets/images/belts.jpeg", title: "All Belts", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/belts.jpeg",
    "assets/images/belts.jpeg",
    "assets/images/belts.jpeg",
  ]),
  ModelCardShop(urlImage: "assets/images/teakwondo-boy.png", title: "Teakwondo Suit", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways.", images: [
    "assets/images/teakwondo-boy.png",
    "assets/images/teakwondo-boy.png",
    "assets/images/teakwondo-boy.png",
  ]),
  ModelCardShop(urlImage: "assets/images/teakwondo.png", title: "Protectors", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/teakwondo.png",
    "assets/images/teakwondo.png",
    "assets/images/teakwondo.png",
  ]),
  ModelCardShop(urlImage: "assets/images/logo.png", title: "Black Belt", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/logo.png",
    "assets/images/logo.png",
    "assets/images/logo.png",
  ]),
   ModelCardShop(urlImage: "assets/images/belts.jpeg", title: "All Belts", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/belts.jpeg",
    "assets/images/belts.jpeg",
    "assets/images/belts.jpeg",
  ]),
  ModelCardShop(urlImage: "assets/images/teakwondo-boy.png", title: "Teakwondo Suit", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways.", images: [
    "assets/images/teakwondo-boy.png",
    "assets/images/teakwondo-boy.png",
    "assets/images/teakwondo-boy.png",
  ]),
  ModelCardShop(urlImage: "assets/images/teakwondo.png", title: "Protectors", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/teakwondo.png",
    "assets/images/teakwondo.png",
    "assets/images/teakwondo.png",
  ]),
  ModelCardShop(urlImage: "assets/images/logo.png", title: "Black Belt", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/logo.png",
    "assets/images/logo.png",
    "assets/images/logo.png",
  ]),
   ModelCardShop(urlImage: "assets/images/belts.jpeg", title: "All Belts", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/belts.jpeg",
    "assets/images/belts.jpeg",
    "assets/images/belts.jpeg",
  ]),
  ModelCardShop(urlImage: "assets/images/teakwondo-boy.png", title: "Teakwondo Suit", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways.", images: [
    "assets/images/teakwondo-boy.png",
    "assets/images/teakwondo-boy.png",
    "assets/images/teakwondo-boy.png",
  ]),
  ModelCardShop(urlImage: "assets/images/teakwondo.png", title: "Protectors", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/teakwondo.png",
    "assets/images/teakwondo.png",
    "assets/images/teakwondo.png",
  ]),
  ModelCardShop(urlImage: "assets/images/logo.png", title: "Black Belt", price: 12.3,bill: 0,quantity: 0, icon: Icons.favorite, flagFav: false, describe: "A cough is a sudden, reflexive action that helps clear the throat and airways. It may sound dry or deep, sometimes coming in short bursts, and can be triggered by dust, cold air, or irritation in the throat. Although often mild, it can be persistent and tiring if it lasts for a long time.", images: [
    "assets/images/logo.png",
    "assets/images/logo.png",
    "assets/images/logo.png",
  ]),
];