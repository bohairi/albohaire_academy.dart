import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/endDrawer.dart/favorite_drawer.dart';
import 'package:buhairi_academy_application/Screens/home/Subscriptions_page.dart';
import 'package:buhairi_academy_application/Screens/home/first_page.dart';
import 'package:buhairi_academy_application/Screens/home/shop_page.dart';
import 'package:buhairi_academy_application/Screens/home/ChatScreen.dart';
import 'package:buhairi_academy_application/Screens/login_registration/model_users.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Homepage extends StatefulWidget {
  ModelUsers modelUsers;
  Homepage({super.key, required this.modelUsers});

  @override
  State<Homepage> createState() => _HomepageState();
}
class _HomepageState extends State<Homepage> {
  List <Widget> bottomBar = [
    Icon(Icons.home,color: Colors.black,),
    Icon(Icons.shopping_bag,color: Colors.black),
    Icon(Icons.credit_card,color: Colors.black),
    Icon(Icons.sports_martial_arts,color: Colors.black),
  ];

  List <Widget> pages = [
    FirstPage(),
    ShopPage(),
    SubscriptionPage(),
    ChatScreen()
  ];

  int index = 0;

  drawerProfile(IconData icon , String title){
    return ListTile(
      leading: Icon(icon,color: Colors.blue,size: 25,),
      title: Text(title,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Splash_Color.login_reg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        automaticallyImplyActions:false ,
        toolbarHeight: 90,
        backgroundColor: Splash_Color.login_reg,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(builder: (BuildContext innerContext){
              return GestureDetector(
                onTap: () => Scaffold.of(innerContext).openDrawer(),
                child: Icon(Icons.person,color: Colors.blue,),
              );
            }),
          Image.asset("assets/images/logo_white.png",width: 100,height: 100,fit: BoxFit.contain,),
          Builder(builder: (BuildContext innerContext){
              return GestureDetector(
                onTap: () => Scaffold.of(innerContext).openEndDrawer(),
                child: Icon(Icons.favorite,color: Colors.blue,),
              );
            }),
          ],
        ),
        // title: ListTile(
        //   leading: Builder(
        //     builder: (BuildContext innerContext){
        //       return GestureDetector(
        //       onTap: () => Scaffold.of(innerContext).openDrawer(),
        //       child: Icon(Icons.person,color: Colors.blue,));},
        //   ),
          // title: Image.asset("assets/images/logo_white.png",width: 50,height: 50,fit: BoxFit.contain,),
        //   trailing: Builder(
        //     builder: (BuildContext innerContext){
        //       return GestureDetector(
        //       onTap: () => Scaffold.of(innerContext).openEndDrawer(),
        //       child: Icon(Icons.favorite,color: Colors.blue));},
        //   ),
        // ),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              drawerProfile(Icons.person, widget.modelUsers.fullName),
              drawerProfile(Icons.calendar_month, widget.modelUsers.age),
              drawerProfile(Icons.location_on, widget.modelUsers.location),
              drawerProfile(Icons.password, widget.modelUsers.password)
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: FavoriteDrawer()
      ),
      body: pages[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white)
        ),
        child: CurvedNavigationBar(items: bottomBar.map((e) => e).toList(),
        onTap: (value) => setState(() {
          index = value;
        }),
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 300),
        color: Colors.blue,
        buttonBackgroundColor: Colors.amber,),
      ),
    );
  }
}