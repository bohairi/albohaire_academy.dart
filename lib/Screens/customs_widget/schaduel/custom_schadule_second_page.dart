import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/model_schaduale.dart';
import 'package:flutter/material.dart';

class CustomSchaduleSecondPage extends StatelessWidget {
  final ModelSchedule modelSchedule;

  const CustomSchaduleSecondPage({
    super.key,
    required this.modelSchedule,
  });

  // 🎨 توليد لون ثابت بناءً على id
  Color getColorFromId(String id) {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.red.shade100,
      Colors.teal.shade100,
      Colors.indigo.shade100,
      Colors.pink.shade100,
    ];

    int index = id.hashCode.abs() % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final Color headerColor =
        getColorFromId(modelSchedule.id ?? modelSchedule.title);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          modelSchedule.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Card (Title + Level)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    modelSchedule.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    modelSchedule.level,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStatePropertyAll(headerColor),
                  dataRowColor: const WidgetStatePropertyAll(Colors.white),
                  columnSpacing: 40,

                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  columns: const [
                    DataColumn(
                      label: Text(
                        "Day",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Time",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],

                  rows: modelSchedule.schedule.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item.day)),
                        DataCell(Text(item.time)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}