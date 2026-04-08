import 'package:buhairi_academy_application/Models/chat_model.dart';
import 'package:buhairi_academy_application/Models/chat_service.dart';
import 'package:buhairi_academy_application/Screens/home/chat_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatListStudent extends StatefulWidget {
  const ChatListStudent({super.key});

  @override
  State<ChatListStudent> createState() => _ChatListStudentState();
}

class _ChatListStudentState extends State<ChatListStudent> {
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

  Future<Map<String, String>> getOtherUserData(ChatModel chat) async {
    final otherUserId = getOtherUserId(chat);

    if (otherUserId.isEmpty) {
      return {
        "name": "Coach",
        "image": "",
      };
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(otherUserId)
          .get();

      if (!doc.exists || doc.data() == null) {
        return {
          "name": "Coach",
          "image": "",
        };
      }

      final data = doc.data()!;
      return {
        "name": (data["fullName"] ??
                data["Full Name"] ??
                data["userName"] ??
                data["user name"] ??
                "Coach")
            .toString(),
        "image": (data["profileImage"] ?? "").toString(),
      };
    } catch (e) {
      debugPrint("getOtherUserData error: $e");
      return {
        "name": "Coach",
        "image": "",
      };
    }
  }

  int getUnreadCount(ChatModel chat) {
    final value = chat.unreadCounts[currentUserId];
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  Color getAvatarColor(int index) {
    final colors = [
      const Color(0xff1565C0),
      const Color(0xff8E24AA),
      const Color(0xff43A047),
      const Color(0xffFB8C00),
      const Color(0xffEF5350),
      const Color(0xff00897B),
    ];
    return colors[index % colors.length];
  }

  Widget buildListAvatar(int index, String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return Container(
        height: 58,
        width: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      );
    }

    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            getAvatarColor(index),
            getAvatarColor(index).withOpacity(0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatModel>>(
      stream: chatService.getUserChats(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final chats = snapshot.data ?? [];

        if (chats.isEmpty) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 70,
                    color: Color(0xff1565C0),
                  ),
                  SizedBox(height: 14),
                  Text(
                    "No chats yet",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your conversations will appear here once you start chatting.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(top: 4, bottom: 16),
          itemCount: chats.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final chat = chats[index];
            final unreadCount = getUnreadCount(chat);
            final hasUnread = unreadCount > 0;

            return FutureBuilder<Map<String, String>>(
              future: getOtherUserData(chat),
              builder: (context, userSnapshot) {
                final userData = userSnapshot.data ??
                    {
                      "name": "Loading...",
                      "image": "",
                    };

                final title = userData["name"] ?? "Coach";
                final otherImageUrl = userData["image"] ?? "";

                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.08),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatDetailsScreen(
                            chatId: chat.chatId,
                            chatTitle: title,
                            otherUserImage: otherImageUrl,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          buildListAvatar(index, otherImageUrl),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: const Color(0xff1F2937),
                                    fontWeight: hasUnread
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  chat.lastMessage.isEmpty
                                      ? "No messages yet"
                                      : chat.lastMessage,
                                  style: TextStyle(
                                    color: hasUnread
                                        ? const Color(0xff374151)
                                        : Colors.grey.shade600,
                                    fontWeight: hasUnread
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: 1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          hasUnread
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEF5350),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffEF5350)
                                            .withOpacity(0.28),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey.shade400,
                                  size: 18,
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}