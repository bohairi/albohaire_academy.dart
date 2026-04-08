import 'package:buhairi_academy_application/Screens/customs_widget/coaches/card_coach_describe.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/model_coach.dart';
import 'package:flutter/material.dart';

class CustomCoachList extends StatelessWidget {
  final ModelCoach modelCoach;

  const CustomCoachList({
    super.key,
    required this.modelCoach,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CardCoachDescribe(modelCoach: modelCoach),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            /// 🔥 Image Avatar
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  modelCoach.urlImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 14),

            /// 🔥 Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modelCoach.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.workspace_premium_rounded,
                        size: 16,
                        color: Color(0xff1565C0),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        modelCoach.level,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 🔥 Arrow
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: const Color(0xff1565C0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Color(0xff1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}