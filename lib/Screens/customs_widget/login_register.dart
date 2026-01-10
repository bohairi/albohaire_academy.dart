import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_button_Login.dart';
import 'package:buhairi_academy_application/Screens/login_registration/model_users.dart';
import 'package:buhairi_academy_application/Screens/login_registration/signup_screen.dart';
import 'package:buhairi_academy_application/Screens/login_registration/singup_sinin_screen.dart';
import 'package:buhairi_academy_application/Screens/introduction/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginRegister extends StatelessWidget {
  LoginRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if(details.delta.dy < 0){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SingupSininScreen(modelUsers: users[0],)));
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                            Lottie.asset("assets/animations/Fist Bump.json"),
              Text(" J O I N   U O R   T E A M ", style: TextStyle(fontSize: 17, fontFamily: "welcomeText"),),
              SizedBox(height: 20,),
              LottieBuilder.asset("assets/animations/Scroll down.json",
              width: 250,
              height: 250,
              fit: BoxFit.contain,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}