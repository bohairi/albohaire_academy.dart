import 'package:buhairi_academy_application/Screens/customs_widget/achievements/custom_achiev_card.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/achievements/model_achievement.dart';
import 'package:flutter/material.dart';

class AchievementsFirstPage extends StatelessWidget {
  AchievementsFirstPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: cards.length, itemBuilder: (context,index){
        return CustomAchievCard(modelAchievement: cards[index]);
      }),
    );
  }
}