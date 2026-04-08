import 'package:buhairi_academy_application/Models/chat_model.dart';
import 'package:buhairi_academy_application/Models/chat_service.dart';
import 'package:buhairi_academy_application/Screens/home/chat_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoachChatListScreen extends StatefulWidget {
  const CoachChatListScreen({super.key});

  @override
  State<CoachChatListScreen> createState() => _CoachChatListScreenState();
}

class _CoachChatListScreenState extends State<CoachChatListScreen> {
  final ChatService chatService = ChatService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
  }

  String getOtherUserId(ChatModel chat) {
    for (final id in chat.participants) {
      if (id != currentUserId) return id;
    }
    return "";
  }

  int getUnreadCount(ChatModel chat) {
    final value = chat.unreadCounts[currentUserId];
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  Future<Map<String, String>> getOtherUserData(ChatModel chat) async {
    final otherUserId = getOtherUserId(chat);

    if (otherUserId.isEmpty) {
      return {"name": "Chat", "image": ""};
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(otherUserId)
              .get();

      if (!doc.exists || doc.data() == null) {
        return {"name": "Chat", "image": ""};
      }

      final data = doc.data()!;
      return {
        "name":
            (data["fullName"] ??
                    data["Full Name"] ??
                    data["userName"] ??
                    data["user name"] ??
                    "Chat")
                .toString(),
        "image": (data["profileImage"] ?? "").toString(),
      };
    } catch (e) {
      debugPrint("getOtherUserData error: $e");
      return {"name": "Chat", "image": ""};
    }
  }

  Widget buildAvatar(String imageUrl) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
    );
  }

  void openChat(ChatModel chat, String title, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => ChatDetailsScreen(
              chatId: chat.chatId,
              chatTitle: title,
              otherUserImage: imageUrl,
            ),
      ),
    );

    chatService
        .markMessagesAsRead(chatId: chat.chatId, currentUserId: currentUserId)
        .catchError((e) {
          debugPrint("markMessagesAsRead error: $e");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Chats")),
      body: StreamBuilder<List<ChatModel>>(
        stream: chatService.getUserChats(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final chats = snapshot.data ?? [];

          if (chats.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final unreadCount = getUnreadCount(chat);

              return FutureBuilder<Map<String, String>>(
                future: getOtherUserData(chat),
                builder: (context, userSnapshot) {
                  final userData =
                      userSnapshot.data ?? {"name": "Loading...", "image": ""};

                  final title = userData["name"] ?? "Chat";
                  final imageUrl = userData["image"] ?? "";

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    leading: buildAvatar(imageUrl),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight:
                            unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      chat.lastMessage.isEmpty
                          ? "No messages yet"
                          : chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight:
                            unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                    trailing:
                        unreadCount > 0
                            ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => openChat(chat, title, imageUrl),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
