import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverStudentsPage extends StatefulWidget {
  const DriverStudentsPage({super.key});

  @override
  State<DriverStudentsPage> createState() => _DriverStudentsPageState();
}

class _DriverStudentsPageState extends State<DriverStudentsPage> {
  final TextEditingController searchController = TextEditingController();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> allStudents = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredStudents = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStudents();

    searchController.addListener(() {
      filterStudents(searchController.text);
    });
  }

  Future<void> loadStudents() async {
    try {
      setState(() {
        isLoading = true;
      });

      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("role", isEqualTo: "user")
          .get();

      allStudents = snapshot.docs;
      filteredStudents = snapshot.docs;

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load students: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void filterStudents(String query) {
    final q = query.trim().toLowerCase();

    setState(() {
      if (q.isEmpty) {
        filteredStudents = allStudents;
      } else {
        filteredStudents = allStudents.where((doc) {
          final data = doc.data();

          final fullName =
              (data["fullName"] ?? data["Full Name"] ?? "").toString().toLowerCase();

          final userName =
              (data["userName"] ?? data["user name"] ?? "").toString().toLowerCase();

          final phone =
              (data["phoneNumber"] ?? "").toString().toLowerCase();

          return fullName.contains(q) ||
              userName.contains(q) ||
              phone.contains(q);
        }).toList();
      }
    });
  }

  String getStudentName(Map<String, dynamic> data) {
    return (data["fullName"] ??
            data["Full Name"] ??
            data["userName"] ??
            data["user name"] ??
            "Student")
        .toString();
  }

  String getPhoneNumber(Map<String, dynamic> data) {
    return (data["phoneNumber"] ?? "No phone number").toString();
  }

  String getAddress(Map<String, dynamic> data) {
    return (data["address"] ?? data["location"] ?? "No location").toString();
  }

  String getImageUrl(Map<String, dynamic> data) {
    return (data["profileImage"] ?? "").toString();
  }

  double? getLatitude(Map<String, dynamic> data) {
    final value = data["latitude"];
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  double? getLongitude(Map<String, dynamic> data) {
    final value = data["longitude"];
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Future<void> callStudent(String phoneNumber) async {
    final cleanedPhone = phoneNumber.trim();
    final Uri phoneUri = Uri(scheme: "tel", path: cleanedPhone);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open phone dialer")),
      );
    }
  }

  Future<void> openStudentLocation({
    required double? latitude,
    required double? longitude,
    required String address,
  }) async {
    Uri mapsUri;

    if (latitude != null && longitude != null) {
      mapsUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
      );
    } else {
      final encodedAddress = Uri.encodeComponent(address);
      mapsUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$encodedAddress",
      );
    }

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(
        mapsUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
      );
    }
  }

  void showStudentDetails(Map<String, dynamic> data) {
    final studentName = getStudentName(data);
    final phoneNumber = getPhoneNumber(data);
    final address = getAddress(data);
    final imageUrl = getImageUrl(data);
    final latitude = getLatitude(data);
    final longitude = getLongitude(data);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage:
                        imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                    child: imageUrl.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    studentName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text("Phone Number"),
                  subtitle: Text(phoneNumber),
                  onTap: () => callStudent(phoneNumber),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.red),
                  title: const Text("Location"),
                  subtitle: Text(address),
                  onTap: () => openStudentLocation(
                    latitude: latitude,
                    longitude: longitude,
                    address: address,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => callStudent(phoneNumber),
                        icon: const Icon(Icons.call),
                        label: const Text("Call"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => openStudentLocation(
                          latitude: latitude,
                          longitude: longitude,
                          address: address,
                        ),
                        icon: const Icon(Icons.map),
                        label: const Text("Open Maps"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildStudentCard(QueryDocumentSnapshot<Map<String, dynamic>> student) {
    final data = student.data();
    final studentName = getStudentName(data);
    final phoneNumber = getPhoneNumber(data);
    final address = getAddress(data);
    final imageUrl = getImageUrl(data);

    return InkWell(
      onTap: () => showStudentDetails(data),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phoneNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students Locations"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by name or phone",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredStudents.isEmpty
                      ? const Center(child: Text("No students found"))
                      : ListView.separated(
                          itemCount: filteredStudents.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return buildStudentCard(filteredStudents[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}