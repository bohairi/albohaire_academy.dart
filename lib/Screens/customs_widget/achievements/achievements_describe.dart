import 'package:buhairi_academy_application/Screens/customs_widget/achievements/model_achievement.dart';
import 'package:flutter/material.dart';

class AchievementsDescribe extends StatelessWidget {
  final ModelAchievement modelAchievement;

  const AchievementsDescribe({
    super.key,
    required this.modelAchievement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Achievement Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 290,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff1565C0),
                        Color(0xff42A5F5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image.network(
                        modelAchievement.urlImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
             
              ],
            ),

            Transform.translate(
              offset: const Offset(0, -18),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 14,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modelAchievement.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1F2937),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 4,
                      width: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xff1565C0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      modelAchievement.describe,
                      style: TextStyle(
                        fontSize: 15.5,
                        color: Colors.grey.shade800,
                        height: 1.7,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}