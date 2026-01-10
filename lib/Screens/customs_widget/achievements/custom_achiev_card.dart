import 'package:buhairi_academy_application/Screens/customs_widget/achievements/achievements_describe.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/achievements/model_achievement.dart';
import 'package:flutter/material.dart';

class CustomAchievCard extends StatelessWidget {
  ModelAchievement modelAchievement;
  CustomAchievCard({super.key, required this.modelAchievement});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AchievementsDescribe(modelAchievement: modelAchievement),)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Card(
          color: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(modelAchievement.urlImage),
                Center(child: Text(modelAchievement.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                Center(child: Text(modelAchievement.subtitle,style: TextStyle(fontSize: 13),))
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}