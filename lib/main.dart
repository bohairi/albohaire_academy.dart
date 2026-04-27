import 'package:buhairi_academy_application/Screens/coach_system/coach_firstPage.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_options.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/contact/custom_contact.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/card_describe_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/custom_card_shop.dart';
import 'package:buhairi_academy_application/Screens/delivery_system/driver_students_page.dart';
import 'package:buhairi_academy_application/Screens/home/first_page.dart';
import 'package:buhairi_academy_application/Screens/home/homePage.dart';
import 'package:buhairi_academy_application/Screens/home/shop_page.dart';
import 'package:buhairi_academy_application/Screens/introduction/app_description.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_text_feild.dart';
import 'package:buhairi_academy_application/Screens/login_registration/signup_screen.dart';
import 'package:buhairi_academy_application/Screens/login_registration/singup_sinin_screen.dart';
import 'package:buhairi_academy_application/Screens/introduction/splash_screen.dart';
import 'package:buhairi_academy_application/Screens/upload_image/upload_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: userState(), debugShowCheckedModeBanner: false);
  }

  StreamBuilder<User?> userState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return FutureBuilder(
            future:
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data!.uid)
                    .get(),
            builder: (context, roleSnapshot) {
              if (!roleSnapshot.hasData) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final doc = roleSnapshot.data!;

              if (!doc.exists) {
                return SingupSininScreen(); // أو صفحة إكمال التسجيل
              }

              final role = doc['role'];

              if (role == "user") {
                return Homepage();
              } else if (role == "coach") {
                return CoachOptions();
              } else if (role == "delivery") {
                return DriverStudentsPage();
              }
              return SingupSininScreen();
            },
          );
        }
        return SingupSininScreen();
      },
    );
  }
}
