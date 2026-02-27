import 'package:flutter/material.dart';

class ModelUsers {
  String? id;
  String? email;
  String fullName;
  String userName;
  String age;
  String location;
  String password;
  ModelUsers({this.id, this.email,required this.fullName, required this.userName, required this.age, required this.location,required this.password});

  ModelUsers copyWith({
    String? id,
    String? email,
    String? fullName,
    String? userName,
    String? age,
    String? location,
    String? password
  }){
    return ModelUsers(id: id?? this.id,email: email?? this.email, fullName: fullName ?? this.fullName, userName: userName ?? this.userName, age: age ?? this.age, location: location ?? this.location, password: password ?? this.password);
  }
  // factory ModelUsers.fromMap(Map<String,dynamic> map,String docID){
  //   return ModelUsers(id: docID,email: map["email"], fullName: map["fullName"], userName: map["userName"], age: map["age"], location: map["location"], password: map["password"]);
  // }

}
List <ModelUsers> users = [
  ModelUsers(fullName: "ahmad mustafa albohaire", userName: "ahmad", age: "22", location: "quraish street", password: "AHMAD@bash111")
];