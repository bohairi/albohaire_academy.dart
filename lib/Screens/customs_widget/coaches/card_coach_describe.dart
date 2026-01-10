import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/model_coach.dart';
import 'package:buhairi_academy_application/Screens/introduction/splash_screen.dart';
import 'package:flutter/material.dart';

class CardCoachDescribe extends StatelessWidget {
  ModelCoach modelCoach;
  CardCoachDescribe({super.key, required this.modelCoach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(backgroundColor: Colors.grey.shade200,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(modelCoach.urlImage,
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,),
              SizedBox(height: 10,),
              Text(modelCoach.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 10,),
              Text(modelCoach.describe, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            ],
          ),
        ),
      ),
    );
  }
}