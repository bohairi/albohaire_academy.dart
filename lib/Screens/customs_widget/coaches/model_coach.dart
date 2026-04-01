import 'package:flutter/material.dart';

class ModelCoach {
  String? id;
  String urlImage;
  String name;
  String level;
  String describe;
  ModelCoach({
    this.id,
    required this.urlImage,
    required this.name,
    required this.level,
    required this.describe,
  });

  ModelCoach copyWith({
    String? id,
    String? urlImage,
    String? name,
    String? level,
    String? describe}
  ){
    return ModelCoach(id: id?? this.id,urlImage: urlImage ?? this.urlImage, name: name ?? this.name, level: level ?? this.level, describe: describe?? this.describe);
  }

//toMap
  Map<String,dynamic> toMap(){
    return {
      "id" : id,
      "urlImage" : urlImage,
      "name" : name,
      "level" : level,
      "describe" : describe
    };
  }
//fromMap 
  factory ModelCoach.fromMap(Map<String,dynamic> map, String id){
    return ModelCoach(id: id,urlImage: map["urlImage"], name: map["name"], level: map["level"], describe: map["describe"]);
  }
}

// List<ModelCoach> allChoaches = [
//   ModelCoach(
//     urlImage: "assets/images/captin_mustafa.png",
//     name: "Choach Mustafa",
//     level: "8 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
//   ModelCoach(
//     urlImage: "assets/images/captin_laila.png",
//     name: "Choach Laila",
//     level: "6 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
//   ModelCoach(
//     urlImage: "assets/images/captin_yousef.png",
//     name: "Choach Yousef",
//     level: "6 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
//   ModelCoach(
//     urlImage: "assets/images/captin_mohammad.png",
//     name: "Choach Mohammad",
//     level: "5 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
//   ModelCoach(
//     urlImage: "assets/images/captin_hamza.png",
//     name: "Choach Hamza",
//     level: "4 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
//   ModelCoach(
//     urlImage: "assets/images/captin_ahmad.png",
//     name: "Choach Ahmad",
//     level: "4 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
//   ModelCoach(
//     urlImage: "assets/images/captin_oday.png",
//     name: "Choach Oday",
//     level: "4 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
//   ModelCoach(
//     urlImage: "assets/images/captin_bra'.png",
//     name: "Choach Braa'",
//     level: "4 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
//   ModelCoach(
//     urlImage: "assets/images/captin_rama.png",
//     name: "Choach Rama",
//     level: "4 Dan",
//     describe:
//         "A professional Taekwondo coach with extensive experience in training students of all ages and skill levels. He believes that Taekwondo is not only a martial art but a way of life that builds discipline, respect, and self-confidence. His training approach focuses on developing physical strength, technical skills, and strong character, while creating a safe and motivating environment that helps athletes reach their full potential.",
//   ),
// ];
