import 'package:flutter/material.dart';

class ModelSchaduale {
  String title;
  String level;
  int id;
  ModelSchaduale({required this.title, required this.level, required this.id});}

List <DataTable> tables = [
DataTable(
headingRowColor: WidgetStateProperty.all(Colors.amber.shade200),
  columns: const [
    DataColumn(label: Text('Day')),
    DataColumn(label: Text('Time')),
  ],
  rows: const [
    DataRow( color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Monday')), DataCell(Text('04:00 - 05:15 PM'))]),
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Wednesday')), DataCell(Text('04:00 - 05:15 PM'))]),
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('saturday')), DataCell(Text('04:00 - 05:15 PM'))]),
  ],
),

DataTable(
  headingRowColor: WidgetStateProperty.all(Colors.blue[200]),
  columns: const [
    DataColumn(label: Text('Day')),
    DataColumn(label: Text('Time')),
  ],
  rows: const [
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Monday')), DataCell(Text('05:15 - 06:30 PM')),]),
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Wednesday')), DataCell(Text('05:15 - 06:30 PM')), ]),
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('saturday')), DataCell(Text('05:15 - 06:30 PM')),]),
  ],
),

DataTable(
  headingRowColor: WidgetStateProperty.all(Colors.grey[700]),
  columns: const [
    DataColumn(label: Text('Day')),
    DataColumn(label: Text('Time')),
  ],
  rows: const [
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Tuesday')), DataCell(Text('06:30 - 08:00 PM'))]),
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Thursday')), DataCell(Text('06:30 - 08:00 PM'))]),
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Sunday')), DataCell(Text('06:30 - 08:00 PM')),]),
  ],
),

DataTable(
  headingRowColor: WidgetStateProperty.all(Colors.pink[100]),
  columns: const [
    DataColumn(label: Text('Day')),
    DataColumn(label: Text('Time')),
  ],
  rows: const [
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Tuesday')), DataCell(Text('05:00 - 05:15 PM'))]),
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Thursday')), DataCell(Text('05:01 - 05:16 PM'))]),
    DataRow(color: WidgetStatePropertyAll(Colors.white),cells: [DataCell(Text('Sunday')), DataCell(Text('05:00 - 05:15 PM')),]),
  ],
)
];
