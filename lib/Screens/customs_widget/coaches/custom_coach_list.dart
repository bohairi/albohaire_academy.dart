import 'package:buhairi_academy_application/Screens/customs_widget/coaches/card_coach_describe.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/model_coach.dart';
import 'package:flutter/material.dart';


class CustomCoachList extends StatelessWidget {
  ModelCoach modelCoach;
  CustomCoachList({super.key, required this.modelCoach});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder:(_) => CardCoachDescribe(modelCoach: modelCoach))) ,
        child: ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ), 
          leading: Image.asset(modelCoach.urlImage),
          title: Text(modelCoach.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          subtitle: Text(modelCoach.level,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
