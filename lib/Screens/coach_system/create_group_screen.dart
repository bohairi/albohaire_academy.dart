import 'package:buhairi_academy_application/Services/group_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final GroupService groupService = GroupService();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> allStudents = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredStudents = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> selectedStudents = [];

  bool isLoading = true;
  bool isSaving = false;

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

          return fullName.contains(q) || userName.contains(q);
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

  bool isStudentSelected(String studentId) {
    return selectedStudents.any((student) => student.id == studentId);
  }

  void toggleStudentSelection(QueryDocumentSnapshot<Map<String, dynamic>> student) {
    setState(() {
      if (isStudentSelected(student.id)) {
        selectedStudents.removeWhere((s) => s.id == student.id);
      } else {
        selectedStudents.add(student);
      }
    });
  }

  void selectAllStudents() {
    setState(() {
      selectedStudents = List.from(allStudents);
    });
  }

  Future<void> saveGroup() async {
    final groupName = groupNameController.text.trim();

    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter group name")),
      );
      return;
    }

    if (selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one student")),
      );
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      final memberIds = selectedStudents.map((e) => e.id).toList();
      final memberNames =
          selectedStudents.map((e) => getStudentName(e.data())).toList();

      await groupService.createGroup(
        groupName: groupName,
        memberIds: memberIds,
        memberNames: memberNames,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Group created successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create group: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                labelText: "Group Name",
                hintText: "Black Belt Team",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search student",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectAllStudents,
                child: const Text("Select All Club Members"),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: filteredStudents.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        final data = student.data();
                        final studentName = getStudentName(data);
                        final selected = isStudentSelected(student.id);

                        return ListTile(
                          title: Text(studentName),
                          subtitle: Text((data["email"] ?? "").toString()),
                          trailing: Icon(
                            selected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selected ? Colors.green : Colors.grey,
                          ),
                          onTap: () {
                            toggleStudentSelection(student);
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveGroup,
                child: Text(isSaving ? "Saving..." : "Create Group"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupNameController.dispose();
    searchController.dispose();
    super.dispose();
  }
}