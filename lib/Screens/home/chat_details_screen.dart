import 'package:buhairi_academy_application/Models/chat_service.dart';
import 'package:buhairi_academy_application/Models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String chatId;
  final String chatTitle;

  const ChatDetailsScreen({
    super.key,
    required this.chatId,
    required this.chatTitle,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final ChatService chatService = ChatService();
  final TextEditingController messageController = TextEditingController();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String currentUserName = "User";

  @override
  void initState() {
    super.initState();
    loadCurrentUserName();

    chatService.markMessagesAsRead(
      chatId: widget.chatId,
      currentUserId: currentUserId,
    );
  }

  Future<void> loadCurrentUserName() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .get();

      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      setState(() {
        currentUserName = (data["fullName"] ??
                data["Full Name"] ??
                data["userName"] ??
                data["user name"] ??
                "User")
            .toString();
      });
    } catch (_) {}
  }

  Future<void> sendCurrentMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    await chatService.sendMessage(
      chatId: widget.chatId,
      senderId: currentUserId,
      senderName: currentUserName,
      text: text,
    );

    messageController.clear();
  }

  Widget buildMessageBubble(MessageModel message) {
    final bool isMe = message.senderId == currentUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              message.text,
              style: const TextStyle(color: Colors.white),
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
        title: Text(widget.chatTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: chatService.getChatMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text("No messages yet"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return buildMessageBubble(messages[index]);
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Write a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: sendCurrentMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}