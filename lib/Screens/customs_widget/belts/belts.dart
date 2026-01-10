import 'package:flutter/material.dart';

class Belts extends StatelessWidget {
  const Belts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset("assets/images/belts.jpeg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,),
      ),
    );
  }
}