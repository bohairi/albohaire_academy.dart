import 'package:buhairi_academy_application/Models/chat_model.dart';
import 'package:buhairi_academy_application/Models/chat_service.dart';
import 'package:buhairi_academy_application/Screens/home/chat_details_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatService.markAllChatsAsReadForUser(currentUserId);
    });
  }

  String getOtherParticipantName(ChatModel chat) {
    if (chat.participantNames.isEmpty) return "Chat";

    if (chat.participantNames.length == 1) {
      return chat.participantNames.first;
    }

    return chat.participantNames.last;
  }

  int getUnreadCount(ChatModel chat) {
    final value = chat.unreadCounts[currentUserId];
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
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
          return const Center(
            child: Text(
              "No chats yet",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.separated(
          itemCount: chats.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.white24),
          itemBuilder: (context, index) {
            final chat = chats[index];
            final title = getOtherParticipantName(chat);
            final unreadCount = getUnreadCount(chat);

            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                chat.lastMessage.isEmpty ? "No messages yet" : chat.lastMessage,
                style: TextStyle(
                  color: unreadCount > 0 ? Colors.white : Colors.white70,
                  fontWeight:
                      unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: unreadCount > 0
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
                  : const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white54,
                      size: 16,
                    ),
              onTap: () async {
                await chatService.markMessagesAsRead(
                  chatId: chat.chatId,
                  currentUserId: currentUserId,
                );

                if (!context.mounted) return;

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatDetailsScreen(
                      chatId: chat.chatId,
                      chatTitle: title,
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