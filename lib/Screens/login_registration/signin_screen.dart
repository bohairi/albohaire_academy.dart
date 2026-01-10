import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_button_Login.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_text_feild.dart';
import 'package:buhairi_academy_application/Screens/home/homePage.dart';
import 'package:buhairi_academy_application/Screens/login_registration/model_users.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  ModelUsers modelUsers;
  // String name;
  // int age;
  // String location;
  SigninScreen({super.key,required this.modelUsers});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final userNameSignin = TextEditingController();

  final passwordSignin = TextEditingController();

  final _Formkey = GlobalKey<FormState>();
  bool flagVisibility = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _Formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFeild(
                obSecureText: false,
                  name: "User Name",
                  lable: "user name",
                  hintText: "User Name",
                  type: TextInputType.text,
                  icon: Icon(Icons.person, color: Colors.white),
                  controller: userNameSignin,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "please inter your user name";
                    }
                    if (!RegExp(r'^[A-Za-z\u0600-\u06FF]').hasMatch(value)) {
                      return 'The text must start with a letter';
                    }
                    return null;
                  },
                ),
                CustomTextFeild(
                  obSecureText: flagVisibility,
                  name: "Password",
                  lable: "password",
                  hintText: "Strong password",
                  type: TextInputType.text,
                  icon: InkWell(
                    onTap: () => setState(() {
                      flagVisibility = !flagVisibility;
                    }),
                    child:flagVisibility? Icon(Icons.visibility_off, color: Colors.white) : Icon(Icons.visibility, color: Colors.white) ),
                  controller: passwordSignin,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please write your password!';
                    }
            
                    final strongPasswordRegex = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~%^]).{8,}$',
                    );
            
                    if (!strongPasswordRegex.hasMatch(value)) {
                      return 'Use at least 8 characters with uppercase, lowercase, number, and special character';
                    }
                    
                    return null; // ✔ Strong
                  },
                ),
                SizedBox(height: 20),
              CustomButtonLogin(
                textButton: "S I G N I N",
                onPressed: () {
                  if (_Formkey.currentState!.validate() && widget.modelUsers.userName == userNameSignin.text.trim() && widget.modelUsers.password == passwordSignin.text.trim()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Your informations are correct"))
                    );
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Homepage(modelUsers: widget.modelUsers,)));
                  }
                  if(widget.modelUsers.userName != userNameSignin.text.trim() || widget.modelUsers.password != passwordSignin.text.trim()){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Your informations are uncorrect!"))
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}