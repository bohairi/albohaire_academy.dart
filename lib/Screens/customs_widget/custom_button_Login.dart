import 'package:flutter/material.dart';

class CustomButtonLogin extends StatelessWidget {
  String textButton;
  VoidCallback onPressed;
  CustomButtonLogin({super.key,required this.textButton, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Center(
          child: Text(textButton
            ,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "LoginSignup",
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
