import 'package:buhairi_academy_application/Screens/customs_widget/contact/custom_contact.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/card_describe_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/custom_card_shop.dart';
import 'package:buhairi_academy_application/Screens/home/first_page.dart';
import 'package:buhairi_academy_application/Screens/home/homePage.dart';
import 'package:buhairi_academy_application/Screens/home/shop_page.dart';
import 'package:buhairi_academy_application/Screens/introduction/app_description.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_text_feild.dart';
import 'package:buhairi_academy_application/Screens/login_registration/signup_screen.dart';
import 'package:buhairi_academy_application/Screens/login_registration/singup_sinin_screen.dart';
import 'package:buhairi_academy_application/Screens/introduction/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomepageCardDescribeShop {
}
