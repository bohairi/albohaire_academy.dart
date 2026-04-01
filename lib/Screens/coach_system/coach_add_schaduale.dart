import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/ScheduleRow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CoachAddSchaduale extends StatefulWidget {
  const CoachAddSchaduale({super.key});

  @override
  State<CoachAddSchaduale> createState() => _CoachAddSchadualeState();
}

class _CoachAddSchadualeState extends State<CoachAddSchaduale> {
  TextEditingController title = TextEditingController();
  TextEditingController level = TextEditingController();

  bool isLoading = false;

  List<ScheduleRowModel> scheduleList = [
    ScheduleRowModel(day: "Saturday", time: ""),
  ];

  final List<String> days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Schedule", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            customTextField(title, "Title", 1),
            customTextField(level, "Level", 1),

            const SizedBox(height: 10),

            const Text(
              "Schedule Days & Time",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...List.generate(scheduleList.length, (index) {
              return scheduleRow(index);
            }),

            const SizedBox(height: 10),

            customButton(
              nameOf: "Add Day",
              onPressed: () {
                setState(() {
                  scheduleList.add(
                    ScheduleRowModel(day: "Saturday", time: ""),
                  );
                });
              },
            ),

            const SizedBox(height: 15),

            customButton(
              nameOf: "Save Schedule",
              onPressed: saveSchedule,
            ),
          ],
        ),
      ),
    );
  }

  Widget scheduleRow(int index) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: scheduleList[index].day,
              items: days
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  scheduleList[index].day = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Day",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (picked != null) {
                  final String formattedTime = picked.format(context);

                  setState(() {
                    scheduleList[index].time = formattedTime;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  scheduleList[index].time.isEmpty
                      ? "Select Time"
                      : scheduleList[index].time,
                  style: TextStyle(
                    color: scheduleList[index].time.isEmpty
                        ? Colors.grey
                        : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (scheduleList.length > 1)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      scheduleList.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> saveSchedule() async {
    if (title.text.trim().isEmpty || level.text.trim().isEmpty) {
      showMessage("Please fill title and level");
      return;
    }

    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i].day.trim().isEmpty ||
          scheduleList[i].time.trim().isEmpty) {
        showMessage("Please complete all day and time fields");
        return;
      }
    }

    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseFirestore.instance.collection("schedules").add({
        "title": title.text.trim(),
        "level": level.text.trim(),
        "schedule": scheduleList.map((e) => e.toMap()).toList(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      showMessage("Schedule added successfully");

      title.clear();
      level.clear();

      setState(() {
        scheduleList = [
          ScheduleRowModel(day: "Saturday", time: ""),
        ];
      });
    } catch (e) {
      showMessage("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget customTextField(
    TextEditingController controller,
    String hint,
    int maxlines,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        maxLines: maxlines,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  Widget customButton({
    required String nameOf,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    nameOf,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    title.dispose();
    level.dispose();
    super.dispose();
  }
}