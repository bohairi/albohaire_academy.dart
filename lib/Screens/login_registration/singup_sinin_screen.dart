import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/login_registration/model_users.dart';
import 'package:buhairi_academy_application/Screens/login_registration/signin_screen.dart';
import 'package:buhairi_academy_application/Screens/login_registration/signup_screen.dart';
import 'package:flutter/material.dart';

class SingupSininScreen extends StatefulWidget {
  ModelUsers modelUsers;
  SingupSininScreen({super.key, required this.modelUsers});

  @override
  State<SingupSininScreen> createState() => _SingupSininScreenState();
}

class _SingupSininScreenState extends State<SingupSininScreen> with SingleTickerProviderStateMixin{

  late TabController _tabController;
  late String currentUserName;
  late String currentPassword;
 @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    currentUserName = widget.modelUsers.userName;
    currentPassword = widget.modelUsers.userName;
  }
  @override
void dispose() {
  _tabController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Splash_Color.login_reg,
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: Image.asset("assets/images/logo_white.png",height: 60,),
        backgroundColor: Splash_Color.login_reg,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
          Tab(
            child: Text("Singup",style: TextStyle(fontSize: 20,color: Colors.white),),
          ),
          Tab(
            child: Text("Singin",style: TextStyle(fontSize: 20,color: Colors.white),),
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
        SignupScreen(onSignupSuccess: (newUserName,newPassword) {
          setState(() {
            currentUserName = newUserName;
            currentPassword = newPassword;
          });
          _tabController.animateTo(1);
        },),
        SigninScreen(modelUsers: users.last)
      ]),
    );
  }
}