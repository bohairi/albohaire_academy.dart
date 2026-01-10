import 'package:flutter/material.dart';

class CustomSchaduleSecondPage extends StatelessWidget {
  DataTable table;
  CustomSchaduleSecondPage({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(backgroundColor: Colors.grey.shade200,),
      body: Center(
        child: table,
      ),
    );
  }
}