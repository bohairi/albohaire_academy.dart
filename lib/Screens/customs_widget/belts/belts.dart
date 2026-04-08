import 'package:flutter/material.dart';

class Belts extends StatelessWidget {
  const Belts({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BeltModel> belts = [
      BeltModel(
        name: "White Belt",
        subtitle: "Beginning level",
        colors: [Colors.white, Colors.white],
        textColor: Colors.black87,
      ),
      BeltModel(
        name: "Yellow Belt",
        subtitle: "Basic foundation",
        colors: [Color(0xffFDD835), Color(0xffFFEE58)],
      ),
      BeltModel(
        name: "Yellow + Green",
        subtitle: "Improving basics",
        colors: [Color(0xffFDD835), Color(0xff43A047)],
      ),
      BeltModel(
        name: "Green Belt",
        subtitle: "Better control and movement",
        colors: [Color(0xff43A047), Color(0xff2E7D32)],
      ),
      BeltModel(
        name: "Green + Blue",
        subtitle: "Growing technical skills",
        colors: [Color(0xff43A047), Color(0xff1565C0)],
      ),
      BeltModel(
        name: "Blue Belt",
        subtitle: "Stronger performance",
        colors: [Color(0xff1E88E5), Color(0xff0D47A1)],
      ),
      BeltModel(
        name: "Blue + Brown",
        subtitle: "Advanced transition level",
        colors: [Color(0xff1565C0), Color(0xff6D4C41)],
      ),
      BeltModel(
        name: "Brown Belt",
        subtitle: "Advanced discipline",
        colors: [Color(0xff8D6E63), Color(0xff5D4037)],
      ),
      BeltModel(
        name: "Brown + Red",
        subtitle: "Near expert level",
        colors: [Color(0xff6D4C41), Color(0xffE53935)],
      ),
      BeltModel(
        name: "Red Belt",
        subtitle: "High level power and focus",
        colors: [Color(0xffFF5252), Color(0xffC62828)],
      ),
      BeltModel(
        name: "Black Belt",
        subtitle: "Mastery and excellence",
        colors: [Color(0xff212121), Color(0xff000000)],
        textColor: Colors.white,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Belt System",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1565C0),
                  Color(0xff42A5F5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Taekwondo Belt Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Follow the journey from white belt to black belt",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: belts.length,
              itemBuilder: (context, index) {
                final belt = belts[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xff1565C0).withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1565C0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  belt.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1F2937),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  belt.subtitle,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                BeltPreview(
                                  colors: belt.colors,
                                  textColor: belt.textColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BeltModel {
  final String name;
  final String subtitle;
  final List<Color> colors;
  final Color textColor;

  BeltModel({
    required this.name,
    required this.subtitle,
    required this.colors,
    this.textColor = Colors.white,
  });
}

class BeltPreview extends StatelessWidget {
  final List<Color> colors;
  final Color textColor;

  const BeltPreview({
    super.key,
    required this.colors,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.first,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.length > 1 ? colors.last : colors.first,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 26,
            height: 34,
            decoration: BoxDecoration(
              color: colors.length > 1 ? colors.last : colors.first,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Colors.black12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}