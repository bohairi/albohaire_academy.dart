import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomContact extends StatelessWidget {
  const CustomContact({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );

      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'تعذر الاتصال بالرقم $phoneNumber';
      }
    }

    Future<void> launchLink(String url) async {
      final Uri uri = Uri.parse(url);

      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    Widget socialButton({
      required String title,
      required String subtitle,
      required String animationPath,
      required VoidCallback onTap,
      required List<Color> colors,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.08),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: LottieBuilder.asset(
                        animationPath,
                        height: 52,
                        width: 52,
                      ),
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
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: colors.last.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: colors.last,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget phoneCard({
      required String branchName,
      required String phoneNumber,
      required List<Color> colors,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.08),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => makePhoneCall(phoneNumber),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: LottieBuilder.asset(
                        "assets/animations/Phone Call.json",
                        height: 52,
                        width: 52,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          branchName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1F2937),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap to call this branch directly",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: colors.last.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.call_rounded,
                      color: colors.last,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
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
                    "Buhairi Academy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Reach us easily through social media or phone numbers",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    socialButton(
                      title: "Facebook",
                      subtitle: "Open the academy Facebook page",
                      animationPath: "assets/animations/Facebook.json",
                      onTap: () => launchLink(
                        "https://www.facebook.com/buheri.center/",
                      ),
                      colors: const [
                        Color(0xff1877F2),
                        Color(0xff42A5F5),
                      ],
                    ),
                    socialButton(
                      title: "Instagram",
                      subtitle: "Visit the academy Instagram account",
                      animationPath: "assets/animations/Instagram.json",
                      onTap: () => launchLink(
                        "https://www.instagram.com/albuhairi_taekwondo_academy/",
                      ),
                      colors: const [
                        Color(0xffC13584),
                        Color(0xffF77737),
                      ],
                    ),
                    socialButton(
                      title: "WhatsApp",
                      subtitle: "Chat with the academy on WhatsApp",
                      animationPath: "assets/animations/whatsapp_loop.json",
                      onTap: () => launchLink(
                        "https://wa.me/0795747855",
                      ),
                      colors: const [
                        Color(0xff25D366),
                        Color(0xff66BB6A),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Branches",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    phoneCard(
                      branchName: "St. Yarmouk",
                      phoneNumber: "0795747855",
                      colors: const [
                        Color(0xffEF5350),
                        Color(0xffE57373),
                      ],
                    ),
                    phoneCard(
                      branchName: "St. Thirty",
                      phoneNumber: "0797465252",
                      colors: const [
                        Color(0xffFB8C00),
                        Color(0xffFFB74D),
                      ],
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