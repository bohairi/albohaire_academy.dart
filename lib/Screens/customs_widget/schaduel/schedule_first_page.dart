import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/custom_shadule_first_page.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/model_schaduale.dart';
import 'package:flutter/material.dart';

class ScheduleFirstPage extends StatelessWidget {
  ScheduleFirstPage({super.key});
  List <ModelSchaduale> classes = [
    ModelSchaduale(title: "Boys' classes", level: "white and yellow", id: 0),
    ModelSchaduale(title: "Boys' classes", level: "green - brown",id: 1),
    ModelSchaduale(title: "Boys' classes", level: "red and black",id: 2),
    ModelSchaduale(title: "girls' classes", level: "white - black",id: 3),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: classes.map((c) => CustomShaduleFirstPage(modelSchaduale: c)).toList(),
        ),
      ),
    );
  }
}