import 'package:buhairi_academy_application/Screens/customs_widget/achievements/achievements_first_page.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/belts/belts.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/custom_card_coach.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/contact/custom_contact.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_home_card.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/schedule_first_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late List<CustomHomeCard> boxes;
  late List<CustomHomeCard> filterdBoxes;

  final CollectionReference<Map<String, dynamic>> sliderRef =
      FirebaseFirestore.instance.collection("home_slider_images");

  @override
  void initState() {
    super.initState();

    boxes = [
      CustomHomeCard(
        icon: Icons.sports_martial_arts,
        title: "Coaches",
        color: Colors.black,
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => CustomCardCoach())),
      ),
      CustomHomeCard(
        icon: Icons.stairs_outlined,
        title: "Belt System",
        color: Colors.white,
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => Belts())),
      ),
      CustomHomeCard(
        icon: Icons.emoji_events,
        title: "Achievements",
        color: const Color.fromARGB(255, 216, 161, 9),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AchievementsFirstPage())),
      ),
      CustomHomeCard(
        icon: Icons.schedule,
        title: "Schedule",
        color: const Color.fromARGB(255, 157, 7, 7),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ScheduleFirstPage())),
      ),
      CustomHomeCard(
        icon: Icons.contact_phone,
        title: "Contact Us",
        color: const Color.fromARGB(255, 121, 218, 124),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => CustomContact())),
      ),
    ];

    filterdBoxes = boxes;
  }

  void searchInEditText(String value) {
    setState(() {
      if (value.isEmpty) {
        filterdBoxes = boxes;
      } else {
        filterdBoxes = boxes
            .where((c) => c.title.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Widget buildSliderSection() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: sliderRef.orderBy("createdAt", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox(
            height: 220,
            child: Center(child: Text("Error loading images")),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.grey.shade200,
            ),
            child: const Center(
              child: Text("No images available"),
            ),
          );
        }

        final imageUrls = docs
            .map((doc) => doc.data()["imageUrl"]?.toString() ?? "")
            .where((url) => url.isNotEmpty)
            .toList();

        return CarouselSlider(
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: imageUrls.map((url) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: filterdBoxes.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: filterdBoxes[index],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff1565C0),
                    Color(0xff42A5F5),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(14),
              child: TextField(
                onChanged: searchInEditText,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 14),

            buildSliderSection(),

            const SizedBox(height: 16),

            buildGrid(),
          ],
        ),
      ),
    );
  }
}