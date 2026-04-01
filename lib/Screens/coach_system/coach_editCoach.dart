import 'package:buhairi_academy_application/Screens/customs_widget/coaches/card_coach_describe.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/model_coach.dart';
import 'package:flutter/material.dart';

class CoachEditcoach extends StatelessWidget {
  ModelCoach modelCoach;
  Widget edit;
  Widget delete;
  CoachEditcoach({
    super.key,
    required this.modelCoach,
    required this.edit,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap:
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CardCoachDescribe(modelCoach: modelCoach),
              ),
            ),
        child: Material(
          elevation: 8,
          child: ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            leading: Image.network(modelCoach.urlImage),
            title: Text(
              modelCoach.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(
              modelCoach.level,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        // width: MediaQuery.of(context).size.width * 0.00001,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Edit"), edit],
                            ),
                            Divider(color: Colors.grey, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Delete"), delete],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ),
      ),
    );
  }
}
