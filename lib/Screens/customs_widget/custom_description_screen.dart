import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:flutter/material.dart';

class CustomDescriptionScreen extends StatelessWidget {
  String urlImage;
  String title;
  RichText subtitle;
  CustomDescriptionScreen({super.key, required this.urlImage, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: Splash_Color.splash_Color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(urlImage,
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
            fit: BoxFit.fill,),
            SizedBox(height: 20,),
            Center(child: Text(title,style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),)),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.93,
                  child: subtitle),
              ],
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}