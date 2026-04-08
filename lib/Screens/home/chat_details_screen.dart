import 'package:buhairi_academy_application/Models/chat_service.dart';
import 'package:buhairi_academy_application/Models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String chatId;
  final String chatTitle;
  final String? otherUserImage;

  const ChatDetailsScreen({
    super.key,
    required this.chatId,
    required this.chatTitle,
    this.otherUserImage,
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

    chatService
        .markMessagesAsRead(chatId: widget.chatId, currentUserId: currentUserId)
        .catchError((e) {
          debugPrint("markMessagesAsRead error: $e");
        });
  }

  Future<void> loadCurrentUserName() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(currentUserId)
              .get();

      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      setState(() {
        currentUserName =
            (data["fullName"] ??
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
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          gradient:
              isMe
                  ? const LinearGradient(
                    colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                  )
                  : null,
          color: isMe ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
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
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChatAvatar() {
    final imageUrl = (widget.otherUserImage ?? "").trim();

    return CircleAvatar(
      backgroundColor: Colors.white,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child:
          imageUrl.isEmpty
              ? const Icon(Icons.person, color: Color(0xff1565C0))
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        title: Row(
          children: [
            buildChatAvatar(),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.chatTitle,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
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
                    child: Text(
                      "Start the conversation 👋",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: "Write a message...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                      ),
                    ),
                    child: IconButton(
                      onPressed: sendCurrentMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
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
