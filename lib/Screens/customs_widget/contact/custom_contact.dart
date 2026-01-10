import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomContact extends StatelessWidget {
  const CustomContact({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _makePhoneCall(String phoneNumber) async {
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

    method_link(String url,VoidCallback action){
    return InkWell(
      onTap: action,
      child: LottieBuilder.asset(url, 
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width * 0.22,),
    );
  }
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red.shade100,iconTheme: IconThemeData(color: Colors.white),),
      backgroundColor: Colors.red.shade100,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            method_link(
              "assets/animations/Facebook.json",
                  () => launchLink("https://www.facebook.com/buheri.center/"),
            ),
            method_link("assets/animations/Instagram.json",()=> launchLink("https://www.instagram.com/albuhairi_taekwondo_academy/")),
            method_link("assets/animations/whatsapp_loop.json",()=> launchLink("https://wa.me/0795747855")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("st. yarmouk",style: TextStyle(fontWeight: FontWeight.bold),),
                method_link("assets/animations/Phone Call.json",(){
                  _makePhoneCall("0795747855");
                }),
                Text("st. thirty",style: TextStyle(fontWeight: FontWeight.bold),),
                method_link("assets/animations/Phone Call.json",(){
                  _makePhoneCall("0797465252");
                }),
              ],
            ),
          ],
        ),
      ),
    );

    
  }
}