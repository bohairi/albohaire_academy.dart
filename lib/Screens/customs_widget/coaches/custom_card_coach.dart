import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/custom_coach_list.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/model_coach.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          child: StreamBuilder(stream: FirebaseFirestore.instance.collection("Coaches").snapshots(), builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                    return Center(child: Text("There is no data"),);
                  }
                  final coaches = snapshot.data!.docs.map((doc) => ModelCoach.fromMap(doc.data(), doc.id)).toList();
                  return ListView.builder(itemCount: coaches.length,itemBuilder: (context, index) {
                    return CustomCoachList(modelCoach: coaches[index]);
                  },);
                }),
        ),
      ),
    );
  }
}