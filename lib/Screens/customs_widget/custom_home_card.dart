import 'package:flutter/material.dart';

class CustomHomeCard extends StatelessWidget {
  IconData icon;
  String title;
  Color color;
  VoidCallback onTap;
  CustomHomeCard({super.key, required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox
        (
           width: MediaQuery.of(context).size.width *0.5 ,
           height: MediaQuery.of(context).size.height * 0.15,
          child: InkWell(
            onTap: onTap,
            child: Card(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color,size: 50,),
                  Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: color),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}