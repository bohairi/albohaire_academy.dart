import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/endDrawer.dart/favorite_drawer.dart';
import 'package:buhairi_academy_application/Screens/home/Subscriptions_page.dart';
import 'package:buhairi_academy_application/Screens/home/first_page.dart';
import 'package:buhairi_academy_application/Screens/home/shop_page.dart';
import 'package:buhairi_academy_application/Screens/home/ChatScreen.dart';
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

  List<Widget> bottomBar = const [
    Icon(Icons.home, color: Colors.black),
    Icon(Icons.shopping_bag, color: Colors.black),
    Icon(Icons.credit_card, color: Colors.black),
    Icon(Icons.sports_martial_arts, color: Colors.black),
  ];

  List<Widget> pages =  [
    FirstPage(),
    ShopPage(),
    SubscriptionPage(),
    ChatScreen(),
  ];

  int index = 0;

  Widget drawerProfileRow(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildUserDrawer() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text("User data not found"),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final String fullName = data["Full Name"] ?? "No Name";
        final String userName = data["user name"] ?? "No Username";
        final String email = data["email"] ?? "No Email";
        final String age = data["age"] ?? "No Age";
        final String location = data["location"] ?? "No Location";
        final String imageUrl = data["profileImage"] ?? "";

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 45, color: Colors.blue)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "@$userName",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                drawerProfileRow(Icons.email, email),
                drawerProfileRow(Icons.cake, age),
                drawerProfileRow(Icons.location_on, location),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Splash_Color.login_reg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,
        toolbarHeight: 90,
        backgroundColor: Splash_Color.login_reg,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (BuildContext innerContext) {
                return GestureDetector(
                  onTap: () => Scaffold.of(innerContext).openDrawer(),
                  child: const Icon(Icons.person, color: Colors.blue),
                );
              },
            ),
            Image.asset(
              "assets/images/logo_white.png",
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            Builder(
              builder: (BuildContext innerContext) {
                return GestureDetector(
                  onTap: () => Scaffold.of(innerContext).openEndDrawer(),
                  child: const Icon(Icons.favorite, color: Colors.blue),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: buildUserDrawer(),
      ),
      endDrawer: const Drawer(
        child: FavoriteDrawer(),
      ),
      body: pages[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          items: bottomBar,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 300),
          color: Colors.blue,
          buttonBackgroundColor: Colors.amber,
        ),
      ),
    );
  }
}