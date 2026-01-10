import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/custom_schadule_second_page.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/model_schaduale.dart';
import 'package:flutter/material.dart';

class CustomShaduleFirstPage extends StatelessWidget {
  ModelSchaduale modelSchaduale;
  CustomShaduleFirstPage({super.key, required this.modelSchaduale});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder:(_) => CustomSchaduleSecondPage(table: tables[modelSchaduale.id]))) ,
        child: ListTile(
          tileColor: Colors.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ), 
          title: Center(child: Text(modelSchaduale.level, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
          subtitle: Center(child: Text(modelSchaduale.title,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
        ),
      ),
    );
  }
}