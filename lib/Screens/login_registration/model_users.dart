import 'package:flutter/material.dart';

class ModelUsers {
  String fullName;
  String userName;
  String age;
  String location;
  String password;
  ModelUsers({required this.fullName, required this.userName, required this.age, required this.location,required this.password});
}
List <ModelUsers> users = [
  ModelUsers(fullName: "ahmad mustafa albohaire", userName: "ahmad", age: "22", location: "quraish street", password: "AHMAD@bash111")
];