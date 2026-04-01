import 'package:buhairi_academy_application/Screens/coach_system/coach_add_schaduale.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/ScheduleRow.dart';
import 'package:flutter/material.dart';

class ModelSchedule {
  String title;
  String level;
  String? id;
  List<ScheduleRowModel> schedule;

  ModelSchedule({
    this.id,
    required this.title,
    required this.level,
    required this.schedule,
  });

  ModelSchedule copyWith({
    String? title,
    String? level,
    String? id,
    List<ScheduleRowModel>? schedule,
  }) {
    return ModelSchedule(
      title: title ?? this.title,
      level: level ?? this.level,
      id: id ?? this.id,
      schedule: schedule ?? this.schedule,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "level": level,
      "id": id,
      "schedule": schedule.map((e) => e.toMap()).toList(),
    };
  }

  factory ModelSchedule.fromMap(Map<String, dynamic> map, String id) {
    return ModelSchedule(
      id: id,
      title: map["title"] ?? "",
      level: map["level"] ?? "",
      schedule: (map["schedule"] as List<dynamic>? ?? [])
          .map((e) => ScheduleRowModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

// List <DataTable> tables = [
// DataTable(
// headingRowColor: WidgetStateProperty.all(Colors.amber.shade200),
//   columns: const [
//     DataColumn(label: Text('Day')),
//     DataColumn(label: Text('Time')),
//   ],
//   rows: const [
//     DataRow( color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Monday')), DataCell(Text('04:00 - 05:15 PM'))]),
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Wednesday')), DataCell(Text('04:00 - 05:15 PM'))]),
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('saturday')), DataCell(Text('04:00 - 05:15 PM'))]),
//   ],
// ),

// DataTable(
//   headingRowColor: WidgetStateProperty.all(Colors.blue[200]),
//   columns: const [
//     DataColumn(label: Text('Day')),
//     DataColumn(label: Text('Time')),
//   ],
//   rows: const [
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Monday')), DataCell(Text('05:15 - 06:30 PM')),]),
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Wednesday')), DataCell(Text('05:15 - 06:30 PM')), ]),
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('saturday')), DataCell(Text('05:15 - 06:30 PM')),]),
//   ],
// ),

// DataTable(
//   headingRowColor: WidgetStateProperty.all(Colors.grey[700]),
//   columns: const [
//     DataColumn(label: Text('Day')),
//     DataColumn(label: Text('Time')),
//   ],
//   rows: const [
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Tuesday')), DataCell(Text('06:30 - 08:00 PM'))]),
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Thursday')), DataCell(Text('06:30 - 08:00 PM'))]),
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Sunday')), DataCell(Text('06:30 - 08:00 PM')),]),
//   ],
// ),

// DataTable(
//   headingRowColor: WidgetStateProperty.all(Colors.pink[100]),
//   columns: const [
//     DataColumn(label: Text('Day')),
//     DataColumn(label: Text('Time')),
//   ],
//   rows: const [
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Tuesday')), DataCell(Text('05:00 - 05:15 PM'))]),
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Thursday')), DataCell(Text('05:01 - 05:16 PM'))]),
//     DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Sunday')), DataCell(Text('05:00 - 05:15 PM')),]),
//   ],
// )
// ];
