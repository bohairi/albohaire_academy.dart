import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/endDrawer.dart/favorite_drawer.dart';
import 'package:buhairi_academy_application/Screens/home/ChatScreen.dart';
import 'package:buhairi_academy_application/Screens/home/Subscriptions_page.dart';
import 'package:buhairi_academy_application/Screens/home/first_page.dart';
import 'package:buhairi_academy_application/Screens/home/shop_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  int index = 0;

  List<Widget> pages = [
    FirstPage(),
    ShopPage(),
    SubscriptionPage(),
    ChatScreen(),
  ];

  Widget buildUserDrawer() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("User data not found"));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final name = (data["fullName"] ?? "No Name").toString();
        final username = (data["userName"] ?? "No Username").toString();
        final email = (data["email"] ?? "No Email").toString();
        final age = data["age"]?.toString() ?? "No Age";
        final location = (data["address"] ?? "No Location").toString();
        final imageUrl = (data["profileImage"] ?? "").toString();

        return SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1565C0),
                      Color(0xff42A5F5),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.person, size: 40, color: Colors.blue)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@$username",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              drawerItem(Icons.email, email),
              drawerItem(Icons.cake, age),
              drawerItem(Icons.location_on, location),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff1565C0)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),

            Image.asset(
              "assets/images/logo_white.png",
              height: 60,
            ),

            Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      drawer: Drawer(child: buildUserDrawer()),
      endDrawer: const Drawer(child: FavoriteDrawer()),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[index],
      ),

      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home),
          Icon(Icons.shopping_bag),
          Icon(Icons.credit_card),
          Icon(Icons.chat),
        ],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        backgroundColor: Colors.transparent,
        color: const Color(0xff1565C0),
        buttonBackgroundColor: const Color(0xffFFC107),
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}