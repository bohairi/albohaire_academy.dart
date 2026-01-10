import 'package:buhairi_academy_application/Screens/customs_widget/achievements/achievements_first_page.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/belts/belts.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/coaches/custom_card_coach.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/contact/custom_contact.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_home_card.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/schedule_first_page.dart';
import 'package:flutter/material.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';

class FirstPage extends StatefulWidget {
  FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<String> sampleImages = [
    "assets/images/Screenshot 2025-12-30 150159.png",
    "assets/images/Screenshot 2025-12-30 150417.png",
    "assets/images/Screenshot 2025-12-30 150449.png",
    "assets/images/Screenshot 2025-12-30 150505.png",
    "assets/images/Screenshot 2025-12-30 150527.png",
  ];

  late List<CustomHomeCard> boxes;
  late List<CustomHomeCard> filterdBoxes;

  @override
  void initState() {
    super.initState();
    boxes = [
    CustomHomeCard(icon: Icons.sports_martial_arts, title: "Coaches",color: Colors.black,onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CustomCardCoach())),),
    CustomHomeCard(icon: Icons.stairs_outlined, title: "Belt System", color: Colors.white, onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> Belts())),),
    CustomHomeCard(icon: Icons.emoji_events, title: "Achievements",color: const Color.fromARGB(255, 216, 161, 9),onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AchievementsFirstPage())),),
    CustomHomeCard(icon: Icons.schedule, title: "Schedule", color: const Color.fromARGB(255, 157, 7, 7),onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ScheduleFirstPage())),),
    CustomHomeCard(icon: Icons.contact_phone, title: "Contact Us", color: const Color.fromARGB(255, 121, 218, 124),onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CustomContact())),),
  ];
  filterdBoxes = boxes;
  }  

  searchInEditText(String value){
    setState(() {
      if(value.isEmpty){
        filterdBoxes = boxes;
      }
      else{
        filterdBoxes = boxes.where((c)=> c.title.toLowerCase().contains(value.toLowerCase())).toList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              child: TextField(
                onChanged: (value) {
                    searchInEditText(value);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 30),
                  hintText: "Search",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(height: 10),
            FanCarouselImageSlider.sliderType1(
              imagesLink: sampleImages,
              isAssets: true,
              autoPlay: true,
              sliderHeight: MediaQuery.of(context).size.height * 0.25,
              imageFitMode: BoxFit.fill,
              showIndicator: false,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 10,
                childAspectRatio: 1.4,
              ),
              itemCount: filterdBoxes.length,
              itemBuilder: (context, index) {
                return filterdBoxes[index];
              },
            ),
          ],
        ),
      ),
    );
  }
}
