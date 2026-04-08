import 'package:buhairi_academy_application/Screens/coach_system/coach_addCoach.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_add_achievements.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_add_schaduale.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_chat_list_screen.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_firstPage.dart';
import 'package:buhairi_academy_application/Screens/coach_system/coach_manage_slider_page.dart';
import 'package:buhairi_academy_application/Screens/coach_system/create_group_screen.dart';
import 'package:buhairi_academy_application/Screens/coach_system/group_list_screen.dart';
import 'package:buhairi_academy_application/Screens/coach_system/send_message_coach_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoachOptions extends StatefulWidget {
  const CoachOptions({super.key});

  @override
  State<CoachOptions> createState() => _CoachOptionsState();
}

class _CoachOptionsState extends State<CoachOptions> {
  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    final String coachName = nameFromEmail(email).toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xff1565C0),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Coach Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
              decoration: const BoxDecoration(
                color: Color(0xff1565C0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Back,",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Coach $coachName",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.dashboard_customize_rounded,
                            color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Manage your academy content from one place",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    customOption(
                      title: "Home Images",
                      subtitle: "Add and manage slider images",
                      icon: Icons.image_rounded,
                      color: const Color(0xff5C6BC0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachManageSliderPage(),
                          ),
                        );
                      },
                    ),
                    customOption(
                      title: "Add Product",
                      subtitle: "Create and manage products",
                      icon: Icons.shopping_bag_rounded,
                      color: const Color(0xff26A69A),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachFirstpage(),
                          ),
                        );
                      },
                    ),
                    customOption(
                      title: "Add Achievement",
                      subtitle: "Publish academy achievements",
                      icon: Icons.emoji_events_rounded,
                      color: const Color(0xffF9A825),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachAddAchievements(),
                          ),
                        );
                      },
                    ),
                    customOption(
                      title: "Add Coach",
                      subtitle: "Add new coach information",
                      icon: Icons.sports_martial_arts_rounded,
                      color: const Color(0xff8E24AA),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachAddcoach(),
                          ),
                        );
                      },
                    ),
                    customOption(
                      title: "Add Schedule",
                      subtitle: "Manage class schedules",
                      icon: Icons.schedule_rounded,
                      color: const Color(0xffEF5350),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachAddSchaduale(),
                          ),
                        );
                      },
                    ),
                    customOption(
                      title: "Send Message to Student",
                      subtitle: "Send announcements and messages",
                      icon: Icons.send_rounded,
                      color: const Color(0xff1E88E5),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SendMessageCoachScreen(),
                          ),
                        );
                      },
                    ),
                    customOption(
                      title: "View Chats",
                      subtitle: "Open student conversations",
                      icon: Icons.chat_bubble_rounded,
                      color: const Color(0xff43A047),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachChatListScreen(),
                          ),
                        );
                      },
                    ),
                    customOption(
                      title: "Create Group",
                      subtitle: "Create a new student group",
                      icon: Icons.group_add_rounded,
                      color: const Color(0xffFB8C00),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateGroupScreen(),
                          ),
                        );
                      },
                    ),
                    customOption(
                      title: "Groups",
                      subtitle: "View and manage created groups",
                      icon: Icons.groups_rounded,
                      color: const Color(0xff6D4C41),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupListScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String nameFromEmail(String? email) {
    int index = email!.indexOf("@");
    String name = email.substring(0, index);
    return name;
  }

  Widget customOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.12),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F2937),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}