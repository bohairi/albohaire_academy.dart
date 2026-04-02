import 'dart:io';

import 'package:buhairi_academy_application/Screens/customs_widget/custom_button_Login.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_text_feild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  final Function(String, String) onSignupSuccess;

  const SignupScreen({
    super.key,
    required this.onSignupSuccess,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  final email = TextEditingController();
  final fullName = TextEditingController();
  final userName = TextEditingController();
  final age = TextEditingController();
  final location = TextEditingController();
  final password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool flagVisibility = true;
  bool isLoading = false;

  XFile? profileImage;
  String? profileImageUrl;

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    profileImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<String> uploadProfileImage(String uid) async {
    if (profileImage == null) return "";

    final ref = FirebaseStorage.instance
        .ref()
        .child("profile_images/$uid/${profileImage!.name}");

    await ref.putFile(File(profileImage!.path));
    return await ref.getDownloadURL();
  }

  Future<void> addUser(String uid) async {
    await users.doc(uid).set({
      "id": uid,
      "email": email.text.trim(),
      "Full Name": fullName.text.trim(),
      "user name": userName.text.trim(),
      "age": age.text.trim(),
      "location": location.text.trim(),
      "role": "user",
      "profileImage": profileImageUrl ?? "",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<String> signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      return "done";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      }
      return e.message ?? "Signup failed";
    } catch (e) {
      return e.toString();
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickProfileImage,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white24,
                  backgroundImage:
                      profileImage != null ? FileImage(File(profileImage!.path)) : null,
                  child: profileImage == null
                      ? const Icon(Icons.camera_alt, color: Colors.white, size: 30)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Add profile image",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),

              CustomTextFeild(
                name: "Email",
                lable: "email",
                hintText: "name@gmail.com",
                type: TextInputType.emailAddress,
                icon: const Icon(Icons.mail, color: Colors.white),
                controller: email,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'please enter your email!';
                  }

                  if (!RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(value.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                obSecureText: false,
              ),

              CustomTextFeild(
                obSecureText: false,
                name: "Full Name",
                lable: "Name",
                hintText: "first second last",
                type: TextInputType.text,
                icon: const Icon(Icons.person, color: Colors.white),
                controller: fullName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'please enter your name!';
                  }

                  final name = value.trim();

                  if (RegExp(r'\d').hasMatch(name)) {
                    return 'the name must not have numbers';
                  }

                  final parts = name.split(RegExp(r'\s+'));
                  if (parts.length != 3) {
                    return 'the name must contain 3 parts';
                  }
                  return null;
                },
              ),

              CustomTextFeild(
                obSecureText: false,
                name: "User Name",
                lable: "user name",
                hintText: "User Name",
                type: TextInputType.text,
                icon: const Icon(Icons.person, color: Colors.white),
                controller: userName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please enter your user name";
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
                hintText: "Years",
                type: TextInputType.number,
                icon: const Icon(Icons.calendar_month, color: Colors.white),
                controller: age,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'please enter the age!';
                  }

                  final parsedAge = int.tryParse(value);
                  if (parsedAge == null) {
                    return 'the number must be integer';
                  }
                  if (parsedAge < 4 || parsedAge > 30) {
                    return 'the age must be between 4 - 30';
                  }

                  return null;
                },
              ),

              CustomTextFeild(
                obSecureText: false,
                name: "Your Location",
                lable: "location",
                hintText: "streetName, buildingName",
                type: TextInputType.text,
                icon: const Icon(Icons.location_on, color: Colors.white),
                controller: location,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please write your location";
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
                  onTap: () {
                    setState(() {
                      flagVisibility = !flagVisibility;
                    });
                  },
                  child: flagVisibility
                      ? const Icon(Icons.visibility_off, color: Colors.white)
                      : const Icon(Icons.visibility, color: Colors.white),
                ),
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

                  return null;
                },
              ),

              const SizedBox(height: 10),

              CustomButtonLogin(
                textButton: isLoading ? "LOADING..." : "S I G N U P",
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    showMessage("Please complete the fields correctly");
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  try {
                    final result = await signup();

                    if (result != "done") {
                      showMessage(result);
                      return;
                    }

                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser == null) {
                      showMessage("Signup succeeded, but user not found");
                      return;
                    }

                    profileImageUrl = await uploadProfileImage(currentUser.uid);
                    await addUser(currentUser.uid);

                    showMessage("Account created successfully");

                    widget.onSignupSuccess(
                      email.text.trim(),
                      password.text.trim(),
                    );

                    email.clear();
                    fullName.clear();
                    userName.clear();
                    password.clear();
                    age.clear();
                    location.clear();

                    setState(() {
                      profileImage = null;
                    });
                  } catch (e) {
                    showMessage("Error: $e");
                  } finally {
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    fullName.dispose();
    userName.dispose();
    age.dispose();
    location.dispose();
    password.dispose();
    super.dispose();
  }
}