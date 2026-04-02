import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/login_registration/signin_screen.dart';
import 'package:buhairi_academy_application/Screens/login_registration/signup_screen.dart';
import 'package:flutter/material.dart';

class SingupSininScreen extends StatefulWidget {
  const SingupSininScreen({super.key});

  @override
  State<SingupSininScreen> createState() => _SingupSininScreenState();
}

class _SingupSininScreenState extends State<SingupSininScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String lastEmail = "";
  String lastPassword = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: Image.asset(
          "assets/images/logo_white.png",
          height: 60,
        ),
        backgroundColor: Splash_Color.login_reg,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                "Signup",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                "Signin",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SignupScreen(
            onSignupSuccess: (newEmail, newPassword) {
              setState(() {
                lastEmail = newEmail;
                lastPassword = newPassword;
              });
              _tabController.animateTo(1);
            },
          ),
          SigninScreen(
            initialEmail: lastEmail,
            initialPassword: lastPassword,
          ),
        ],
      ),
    );
  }
}