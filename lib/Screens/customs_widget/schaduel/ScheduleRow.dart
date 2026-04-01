class ScheduleRowModel {
  String day;
  String time;

  ScheduleRowModel({
    required this.day,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "day": day,
      "time": time,
    };
  }

  factory ScheduleRowModel.fromMap(Map<String, dynamic> map) {
    return ScheduleRowModel(
      day: map["day"] ?? "",
      time: map["time"] ?? "",
    );
  }
}