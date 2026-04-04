import 'package:buhairi_academy_application/Models/chat_service.dart';
import 'package:buhairi_academy_application/Models/group_model.dart';
import 'package:buhairi_academy_application/Screens/home/chat_details_screen.dart';
import 'package:buhairi_academy_application/Services/group_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessageCoachScreen extends StatefulWidget {
  const SendMessageCoachScreen({super.key});

  @override
  State<SendMessageCoachScreen> createState() => _SendMessageCoachScreenState();
}

class _SendMessageCoachScreenState extends State<SendMessageCoachScreen> {
  final ChatService chatService = ChatService();
  final GroupService groupService = GroupService();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String currentCoachName = "Coach";
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allStudents = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredStudents = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> selectedStudents = [];

  bool isLoadingStudents = true;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    loadCoachName();
    loadStudents();

    searchController.addListener(() {
      filterStudents(searchController.text);
    });
  }

  Future<void> loadCoachName() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .get();

      if (!doc.exists) return;
      final data = doc.data();
      if (data == null) return;

      setState(() {
        currentCoachName = (data["fullName"] ??
                data["Full Name"] ??
                data["userName"] ??
                data["user name"] ??
                "Coach")
            .toString();
      });
    } catch (_) {}
  }

  Future<void> loadStudents() async {
    try {
      setState(() {
        isLoadingStudents = true;
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
          isLoadingStudents = false;
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

  void clearAllStudents() {
    setState(() {
      selectedStudents.clear();
    });
  }

  Future<void> applyGroupMembers(GroupModel group) async {
    final ids = group.memberIds.toSet();

    setState(() {
      selectedStudents =
          allStudents.where((student) => ids.contains(student.id)).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Group '${group.groupName}' selected")),
    );
  }

  Future<void> sendMessageToSelectedStudents() async {
    if (selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one student")),
      );
      return;
    }

    final text = messageController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write a message")),
      );
      return;
    }

    try {
      setState(() {
        isSending = true;
      });

      String? firstChatId;
      String? firstStudentName;

      for (final student in selectedStudents) {
        final studentData = student.data();
        final studentId = student.id;
        final studentName = getStudentName(studentData);

        final chatId = await chatService.createOrGetPrivateChat(
          otherUserId: studentId,
          currentUserName: currentCoachName,
          otherUserName: studentName,
        );

        await chatService.sendMessage(
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentCoachName,
          text: text,
        );

        firstChatId ??= chatId;
        firstStudentName ??= studentName;
      }

      messageController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Message sent to ${selectedStudents.length} students")),
      );

      if (selectedStudents.length == 1 &&
          firstChatId != null &&
          firstStudentName != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatDetailsScreen(
              chatId: firstChatId!,
              chatTitle: firstStudentName!,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send message: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  void showSelectedStudentsDialog() {
    if (selectedStudents.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Selected Students (${selectedStudents.length})"),
        content: SizedBox(
          width: double.maxFinite,
    height: 350,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: selectedStudents.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final student = selectedStudents[index];
              final name = getStudentName(student.data());

              return ListTile(
                dense: true,
                title: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                    toggleStudentSelection(student);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSelectedStudentsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Students: ${selectedStudents.length}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedStudents.isEmpty ? null : showSelectedStudentsDialog,
                  child: const Text("View Selected"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: selectedStudents.isEmpty ? null : clearAllStudents,
                  child: const Text("Clear Selection"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGroupsQuickSection() {
    return StreamBuilder<List<GroupModel>>(
      stream: groupService.getCoachGroups(),
      builder: (context, snapshot) {
        final groups = snapshot.data ?? [];

        if (groups.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Groups",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return ActionChip(
                    label: Text(group.groupName),
                    onPressed: () => applyGroupMembers(group),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildStudentTile(QueryDocumentSnapshot<Map<String, dynamic>> student) {
    final data = student.data();
    final studentName = getStudentName(data);
    final studentEmail = (data["email"] ?? "").toString();
    final bool isSelected = isStudentSelected(student.id);
    final imageUrl = (data["profileImage"] ?? "").toString();

    return InkWell(
      onTap: () => toggleStudentSelection(student),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.25),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    studentEmail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScrollableContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildGroupsQuickSection(),
              const SizedBox(height: 12),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search student by name",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: selectAllStudents,
                  child: const Text("Select All Club Members"),
                ),
              ),
              const SizedBox(height: 12),
              buildSelectedStudentsSection(),
              const SizedBox(height: 12),
              const Text(
                "Students",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        if (isLoadingStudents)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (filteredStudents.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text("No students found")),
          )
        else
          SliverList.separated(
            itemCount: filteredStudents.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: buildStudentTile(filteredStudents[index]),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 0),
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }

  Widget buildBottomComposer() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: messageController,
              maxLines: 3,
              minLines: 2,
              decoration: InputDecoration(
                hintText: "Write your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSending ? null : sendMessageToSelectedStudents,
                child: Text(isSending ? "Sending..." : "Send Message"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Message"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: buildScrollableContent(),
            ),
          ),
          buildBottomComposer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    messageController.dispose();
    super.dispose();
  }
}