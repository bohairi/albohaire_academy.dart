import 'package:buhairi_academy_application/Screens/customs_widget/achievements/achievements_describe.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/achievements/model_achievement.dart';
import 'package:flutter/material.dart';

class CustomEditpost extends StatelessWidget {
  ModelAchievement modelAchievement;
  Widget edit;
  Widget delete;
  CustomEditpost({super.key, required this.modelAchievement,required this.delete,required this.edit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AchievementsDescribe(modelAchievement: modelAchievement),)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
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
                Image.network(modelAchievement.urlImage,
                height: 75,
                fit: BoxFit.fill,),
                Center(child: Text(modelAchievement.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    edit,delete
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}