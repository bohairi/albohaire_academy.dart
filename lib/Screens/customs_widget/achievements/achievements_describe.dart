import 'package:buhairi_academy_application/Screens/customs_widget/achievements/model_achievement.dart';
import 'package:flutter/material.dart';

class AchievementsDescribe extends StatelessWidget {
  ModelAchievement modelAchievement;
  AchievementsDescribe({super.key,required this.modelAchievement});

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
              Image.asset(modelAchievement.urlImage,
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              ),
              SizedBox(height: 10,),
              Text(modelAchievement.title,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text(modelAchievement.describe,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
