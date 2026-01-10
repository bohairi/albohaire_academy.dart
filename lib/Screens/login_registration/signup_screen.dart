import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_button_Login.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_text_feild.dart';
import 'package:buhairi_academy_application/Screens/login_registration/model_users.dart';
import 'package:buhairi_academy_application/Screens/login_registration/signin_screen.dart';
import 'package:buhairi_academy_application/Screens/login_registration/singup_sinin_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final Function(String,String) onSignupSuccess;
  SignupScreen({super.key, required this.onSignupSuccess});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullName = TextEditingController();

  final userName = TextEditingController();

  final age = TextEditingController();

  final location = TextEditingController();

  final password = TextEditingController();

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
                name: "Full Name",
                lable: "Name",
                hintText: "first second last",
                type: TextInputType.text,
                icon: Icon(Icons.person, color: Colors.white),
                controller: fullName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'please inter your name!';
                  }

                  // إزالة المسافات الزائدة
                  final name = value.trim();

                  // التحقق من عدم وجود أرقام
                  if (RegExp(r'\d').hasMatch(name)) {
                    return 'the name must doesn\'t have numbers';
                  }

                  // تقسيم الاسم إلى مقاطع
                  final parts = name.split(RegExp(r'\s+'));

                  if (parts.length != 3) {
                    return 'the name must contain 3 parts';
                  }
                  return null; //  صحيح
                },
              ),
              CustomTextFeild(
                obSecureText: false,
                name: "User Name",
                lable: "user name",
                hintText: "User Name",
                type: TextInputType.text,
                icon: Icon(Icons.person, color: Colors.white),
                controller: userName,
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
                obSecureText: false,
                name: "Your Age",
                lable: "Age",
                hintText: "Year",
                type: TextInputType.number,
                icon: Icon(Icons.calendar_month, color: Colors.white),
                controller: age,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'please inter the age !';
                  }

                  final age = int.tryParse(value);

                  if (age == null) {
                    return 'the number must be integer';
                  }

                  if (age < 4 || age > 30) {
                    return 'the age must be between 4 - 30';
                  }

                  return null; // ✔ صحيح
                },
              ),
              CustomTextFeild(
                obSecureText: false,
                name: "Your Location",
                lable: "location",
                hintText: "streetName, buildingName",
                type: TextInputType.text,
                icon: Icon(Icons.location_on, color: Colors.white),
                controller: location,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please write your location";
                  }
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
                  child:flagVisibility? Icon(Icons.visibility_off, color: Colors.white) : Icon(Icons.visibility, color: Colors.white) ) ,
                controller: password,
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

                  return null; //  Strong
                },
              ),
              SizedBox(height: 10),
              CustomButtonLogin(
                textButton: "S I G N U P",
                onPressed: () {
                  if (_Formkey.currentState!.validate()) {
                    final newUser = ModelUsers(fullName: fullName.text.trim(), userName: userName.text.trim(), age: age.text.trim(), location: location.text.trim(), password: password.text.trim());
                    users.add(newUser);
                    widget.onSignupSuccess(
                      newUser.userName,
                      newUser.password
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
