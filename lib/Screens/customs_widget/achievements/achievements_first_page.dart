import 'package:buhairi_academy_application/Screens/customs_widget/achievements/custom_achiev_card.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/achievements/model_achievement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AchievementsFirstPage extends StatelessWidget {
  AchievementsFirstPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection("achievements").snapshots(), builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return Center(child: Text("There is no Data"),);
        }
        final Posts = snapshot.data!.docs.map((doc) => ModelAchievement.fromMap(doc.data(), doc.id)).toList();
        return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: Posts.length, itemBuilder: (context,index){
          return CustomAchievCard(modelAchievement: Posts[index]);
        });
      }),
    );
  }
}