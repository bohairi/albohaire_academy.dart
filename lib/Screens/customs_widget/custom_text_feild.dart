import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  String name;
  String lable;
  String hintText;
  TextInputType type;
  Widget icon;
  bool obSecureText;
  TextEditingController controller;
  final String? Function(String?)? validator;
  CustomTextFeild({super.key, required this.name, required this.lable, required this.hintText, required this.type, required this.icon, required this.controller,required this.validator, required this.obSecureText});
  @override
  Widget build(BuildContext context) {
    return 
       Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(name,style: TextStyle(fontSize: 15,color: Colors.white),)),
            SizedBox(height: 5,),
            TextFormField(
              obscureText: obSecureText,
              controller: controller,
              validator: validator,
              style: TextStyle(
                color: Colors.white
              ),
              keyboardType: type,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: lable,
                labelStyle: TextStyle(
                  color: const Color.fromARGB(255, 159, 157, 157)
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 159, 157, 157)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2)
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: icon,
              ),
            ),
          ],
        ),
      );
    
  }
}