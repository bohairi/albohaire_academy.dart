import 'package:buhairi_academy_application/Screens/customs_widget/custom_description_screen.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/login_register.dart';
import 'package:buhairi_academy_application/Screens/login_registration/model_users.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppDescription extends StatefulWidget {
  AppDescription({super.key});

  @override
  State<AppDescription> createState() => _AppDescriptionState();
}

class _AppDescriptionState extends State<AppDescription> {
  PageController controller = PageController();

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                flag = (value == 3);
              });
            },
            controller: controller,
            children: [
              CustomDescriptionScreen(
                urlImage: "assets/images/teakwondo-boy.png",
                title: "Teakwondo Sport",
                subtitle: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 17, color: Colors.white),
                    children: [
                      TextSpan(
                        text: "Taekwondo helps improve ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "self-confidence, ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: "physical strength, and ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: "discipline.\n",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),

                      TextSpan(
                        text: "It enhances ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "endurance, ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: "teaches ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "goal ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: "achievement, and promotes ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "healthy ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: "lifestyle.\n",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),

                      TextSpan(
                        text: "Practicing regularly increases ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "energy, ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: "mental focus",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: ", and overall ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "fitness.",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              CustomDescriptionScreen(
                urlImage: "assets/images/teakwondo.png",
                title: "Teakwondo In Jordan",
                subtitle: RichText(
                  text: TextSpan(
                    text: "Taekwondo is a popular",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                    children: [
                      TextSpan(
                        text: " martial art",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: " in Jordan, practiced by people of ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "all ages.\n",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: "The sport has grown steadily",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: " since the 1980s",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text:
                            ", with the Jordanian National Taekwondo Team achieving international success.\n",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text:
                            "Today, it is recognized as one of the leading martial arts in Jordan, with ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "competitions",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: " held regularly at ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "national",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(text: " and ", style: TextStyle(fontSize: 17)),
                      TextSpan(
                        text: "regional",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text: " levels.",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),

              CustomDescriptionScreen(
                urlImage: "assets/images/captin_mustafa.png",
                title: "GM Mustafa Al-Buhairi",
                subtitle: RichText(
                  text: TextSpan(
                    text: "Began his Taekwondo journey in ",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                    children: [
                      TextSpan(
                        text: "1981.\n",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text:
                            "He served in the Armed Forces from 1984 to 1986, during which he trained with the Jordanian National Taekwondo Team.\nThrough the guidance and continuous support of the national team coach at that time, Coach ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "Chen Hua",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                      TextSpan(
                        text:
                            ", who was also the personal coach of His Highness Prince Hassan, Al-Buhairi Taekwondo Center was officially established in ",
                        style: TextStyle(fontSize: 17),
                      ),
                      TextSpan(
                        text: "1994.",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,color: Colors.amber
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              LoginRegister()
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: 17,
            right: 17,
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      controller.nextPage(
                        duration: Duration(microseconds: 300),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Text(
                      flag ? "" : "N E X T",

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,color: Colors.white
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: controller, // PageController
                    count: 4,
                    effect: WormEffect(activeDotColor: Colors.amber,dotColor: const Color.fromARGB(255, 167, 165, 165)), // your preferred effect
                    onDotClicked: (index) {},
                  ),
                  InkWell(
                    onTap: () {
                      controller.jumpToPage(3);
                    },
                    child: Text( flag?
                      "" : "S K I P",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
