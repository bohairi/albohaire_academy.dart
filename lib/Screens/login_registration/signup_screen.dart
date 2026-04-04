import 'dart:io';

import 'package:buhairi_academy_application/Screens/customs_widget/custom_button_Login.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/custom_text_feild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
  final phoneNumber = TextEditingController();
  final dateOfBirth = TextEditingController();
  final address = TextEditingController();
  final password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool flagVisibility = true;
  bool isLoading = false;
  bool isGettingLocation = false;

  XFile? profileImage;
  String? profileImageUrl;

  double? latitude;
  double? longitude;

  Future<void> showImageSourcePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  await pickProfileImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  await pickProfileImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final picker = ImagePicker();
    profileImage = await picker.pickImage(source: source);
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

  Future<void> selectDateOfBirth() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = DateTime(now.year - 10, now.month, now.day);
    final DateTime firstDate = DateTime(1980);
    final DateTime lastDate = DateTime(now.year - 4, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(lastDate) ? lastDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      dateOfBirth.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  int? calculateAgeFromDate(String dateText) {
    try {
      final birthDate = DateTime.parse(dateText);
      final now = DateTime.now();

      int age = now.year - birthDate.year;

      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (_) {
      return null;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      setState(() {
        isGettingLocation = true;
      });

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showMessage("Please turn on location services");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        showMessage("Location permission denied");
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        showMessage("Location permission is permanently denied");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude!,
        longitude!,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.trim().isNotEmpty).toList();

        address.text = parts.join(", ");
      } else {
        address.text = "Lat: $latitude, Lng: $longitude";
      }

      setState(() {});
      showMessage("Location selected successfully");
    } catch (e) {
      showMessage("Failed to get location: $e");
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  Future<void> addUser(String uid) async {
    final calculatedAge = calculateAgeFromDate(dateOfBirth.text.trim());

    await users.doc(uid).set({
      "id": uid,
      "email": email.text.trim(),
      "fullName": fullName.text.trim(),
      "userName": userName.text.trim(),
      "phoneNumber": phoneNumber.text.trim(),
      "dateOfBirth": dateOfBirth.text.trim(),
      "age": calculatedAge,
      "address": address.text.trim(),
      "latitude": latitude,
      "longitude": longitude,
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

  InputDecoration customInputDecoration({
    required String label,
    required String hint,
    required Widget icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
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
            children: [
              GestureDetector(
                onTap: showImageSourcePicker,
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
                name: "Jordan Phone Number",
                lable: "phone number",
                hintText: "07XXXXXXXX",
                type: TextInputType.phone,
                icon: const Icon(Icons.phone, color: Colors.white),
                controller: phoneNumber,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'please enter phone number';
                  }

                  final phone = value.trim();

                  if (!RegExp(r'^07[789]\d{7}$').hasMatch(phone)) {
                    return 'please enter a valid Jordanian phone number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: dateOfBirth,
                readOnly: true,
                onTap: selectDateOfBirth,
                style: const TextStyle(color: Colors.white),
                decoration: customInputDecoration(
                  label: "Date of Birth",
                  hint: "Select date of birth",
                  icon: const Icon(Icons.calendar_month, color: Colors.white),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please select date of birth";
                  }

                  final calculatedAge = calculateAgeFromDate(value.trim());

                  if (calculatedAge == null) {
                    return "invalid date of birth";
                  }

                  if (calculatedAge < 4 || calculatedAge > 30) {
                    return "age must be between 4 and 30";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: address,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: customInputDecoration(
                  label: "Location",
                  hint: "Choose your current location",
                  icon: const Icon(Icons.location_on, color: Colors.white),
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: isGettingLocation ? null : getCurrentLocation,
                    icon: isGettingLocation
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please pick your location";
                  }

                  if (latitude == null || longitude == null) {
                    return "location coordinates are missing";
                  }

                  return null;
                },
                maxLines: 2,
              ),

              if (latitude != null && longitude != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Lat: $latitude\nLng: $longitude",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],

              const SizedBox(height: 16),

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

                  if (profileImage == null) {
                    showMessage("Please choose a profile image");
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
                    phoneNumber.clear();
                    dateOfBirth.clear();
                    address.clear();
                    password.clear();

                    latitude = null;
                    longitude = null;

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
    phoneNumber.dispose();
    dateOfBirth.dispose();
    address.dispose();
    password.dispose();
    super.dispose();
  }
}