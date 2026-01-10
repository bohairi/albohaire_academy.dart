import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/custom_coach_list.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/model_coach.dart';
import 'package:flutter/material.dart';

class CustomCardCoach extends StatelessWidget {
  const CustomCardCoach({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Splash_Color.login_reg,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Splash_Color.login_reg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: allChoaches.map((c) => CustomCoachList(modelCoach: c)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}