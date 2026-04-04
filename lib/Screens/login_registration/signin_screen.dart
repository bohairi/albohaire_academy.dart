import 'package:buhairi_academy_application/Screens/coach_system/coach_options.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_button_Login.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_text_feild.dart';
import 'package:buhairi_academy_application/Screens/delivery_system/delivery_firstPage.dart';
import 'package:buhairi_academy_application/Screens/home/homePage.dart';
import 'package:buhairi_academy_application/Screens/manager_system/manager_firstPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;

  const SigninScreen({
    super.key,
    this.initialEmail,
    this.initialPassword,
  });

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final email = TextEditingController();
  final passwordSignin = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool flagVisibility = true;
  bool isLoading = false;
  bool isGoogleLoading = false;
  bool isResetLoading = false;

  @override
  void initState() {
    super.initState();
    email.text = widget.initialEmail ?? "";
    passwordSignin.text = widget.initialPassword ?? "";
  }

  Future<String> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: passwordSignin.text.trim(),
      );
      return "done";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Wrong email or password.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email format.';
      } else if (e.code == 'too-many-requests') {
        return 'Too many attempts. Try again later.';
      }
      return e.message ?? "Login failed";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> handleUserNavigation() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        showMessage("No logged in user found");
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      if (!doc.exists) {
        showMessage("User data not found in Firestore");
        return;
      }

      final data = doc.data();
      if (data == null) {
        showMessage("User data is empty");
        return;
      }

      final role = data["role"];

      if (role == null) {
        showMessage("User role not found");
        return;
      }

      if (!mounted) return;

      if (role == "user") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      } else if (role == "coach") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CoachOptions()),
        );
      } else if (role == "delivery") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DeliveryFirstpage()),
        );
      } else if (role == "manager") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ManagerFirstpage()),
        );
      } else {
        showMessage("Unknown role: $role");
      }
    } catch (e) {
      showMessage("Error while reading user data: $e");
    }
  }

  Future<void> createGoogleUserIfNeeded(User user) async {
    final userDoc =
        FirebaseFirestore.instance.collection("users").doc(user.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        "id": user.uid,
        "email": user.email ?? "",
        "fullName": user.displayName ?? "",
        "userName": user.displayName ?? "",
        "phoneNumber": "",
        "dateOfBirth": "",
        "age": null,
        "address": "",
        "latitude": null,
        "longitude": null,
        "role": "user",
        "profileImage": user.photoURL ?? "",
        "createdAt": FieldValue.serverTimestamp(),
        "authProvider": "google",
      });
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw Exception("Google sign-in was cancelled");
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithGoogleAndPrepareUser() async {
    final userCredential = await signInWithGoogle();
    final user = userCredential.user;

    if (user == null) {
      showMessage("Google sign-in failed");
      return;
    }

    await createGoogleUserIfNeeded(user);
    await handleUserNavigation();
  }

  Future<void> resetPassword() async {
    final currentEmail = email.text.trim();

    if (currentEmail.isEmpty) {
      showMessage("Please enter your email first");
      return;
    }

    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(currentEmail)) {
      showMessage("Please enter a valid email address");
      return;
    }

    try {
      setState(() {
        isResetLoading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: currentEmail);

      showMessage("Password reset link sent to your email");
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? "Failed to send reset email");
    } catch (e) {
      showMessage("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isResetLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.white.withOpacity(0.06),
        ),
        onPressed: isGoogleLoading
            ? null
            : () async {
                try {
                  setState(() {
                    isGoogleLoading = true;
                  });

                  await signInWithGoogleAndPrepareUser();
                } catch (e) {
                  showMessage("Google sign-in error: $e");
                } finally {
                  if (mounted) {
                    setState(() {
                      isGoogleLoading = false;
                    });
                  }
                }
              },
        icon: isGoogleLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.login, color: Colors.white),
        label: Text(
          isGoogleLoading ? "LOADING..." : "CONTINUE WITH GOOGLE",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFeild(
                name: "Email",
                lable: "email",
                hintText: "name@gmail.com",
                type: TextInputType.emailAddress,
                icon: const Icon(Icons.mail, color: Colors.white),
                controller: email,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
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
                controller: passwordSignin,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your password';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isResetLoading ? null : resetPassword,
                  child: Text(
                    isResetLoading ? "Sending..." : "Forgot Password?",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              CustomButtonLogin(
                textButton: isLoading ? "LOADING..." : "S I G N I N",
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    showMessage("Your information is incorrect");
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  final result = await login();

                  if (result == "done") {
                    await handleUserNavigation();
                  } else {
                    showMessage(result);
                  }

                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white24,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "OR",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              buildGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    passwordSignin.dispose();
    super.dispose();
  }
}