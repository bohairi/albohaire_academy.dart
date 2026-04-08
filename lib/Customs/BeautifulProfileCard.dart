import 'package:flutter/material.dart';

class BeautifulProfileCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;

  const BeautifulProfileCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          /// 🔥 Main Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff1565C0),
                  Color(0xff42A5F5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔥 Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔥 Divider line
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔥 Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.6,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 Profile Image
          Positioned(
            top: -65,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff1565C0),
                    Color(0xff42A5F5),
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 62,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    width: 115,
                    height: 115,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}