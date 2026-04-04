import 'package:buhairi_academy_application/Models/chat_model.dart';
import 'package:buhairi_academy_application/Models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get currentUserId => auth.currentUser!.uid;

  Future<String> createOrGetPrivateChat({
    required String otherUserId,
    required String currentUserName,
    required String otherUserName,
  }) async {
    final ids = [currentUserId, otherUserId]..sort();
    final names = [currentUserName, otherUserName];
    final chatId = ids.join("_");

    final chatDoc = firestore.collection("chats").doc(chatId);
    final snapshot = await chatDoc.get();

    if (!snapshot.exists) {
      final unreadMap = <String, dynamic>{};
      for (final id in ids) {
        unreadMap[id] = 0;
      }

      final chat = ChatModel(
        chatId: chatId,
        type: "private",
        participants: ids,
        participantNames: names,
        unreadCounts: unreadMap,
        lastMessage: "",
        lastMessageTime: null,
        lastSenderId: "",
        createdAt: Timestamp.now(),
      );

      await chatDoc.set(chat.toMap());
    }

    return chatId;
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    final chatRef = firestore.collection("chats").doc(chatId);
    final chatSnapshot = await chatRef.get();

    if (!chatSnapshot.exists) return;

    final chatData = chatSnapshot.data() as Map<String, dynamic>;
    final participants = List<String>.from(chatData["participants"] ?? []);
    final unreadCounts =
        Map<String, dynamic>.from(chatData["unreadCounts"] ?? {});

    for (final participantId in participants) {
      if (participantId == senderId) {
        unreadCounts[participantId] = 0;
      } else {
        final currentCount = (unreadCounts[participantId] ?? 0) as int;
        unreadCounts[participantId] = currentCount + 1;
      }
    }

    final messageRef = chatRef.collection("messages").doc();

    final message = MessageModel(
      messageId: messageRef.id,
      senderId: senderId,
      senderName: senderName,
      text: text.trim(),
      timestamp: Timestamp.now(),
      isRead: false,
    );

    await messageRef.set(message.toMap());

    await chatRef.set({
      "lastMessage": text.trim(),
      "lastMessageTime": Timestamp.now(),
      "lastSenderId": senderId,
      "unreadCounts": unreadCounts,
    }, SetOptions(merge: true));
  }

  Stream<List<ChatModel>> getUserChats(String userId) {
    return firestore
        .collection("chats")
        .where("participants", arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      final chats = snapshot.docs
          .map((doc) => ChatModel.fromMap(doc.data()))
          .toList();

      chats.sort((a, b) {
        final aTime = a.lastMessageTime?.millisecondsSinceEpoch ?? 0;
        final bTime = b.lastMessageTime?.millisecondsSinceEpoch ?? 0;
        return bTime.compareTo(aTime);
      });

      return chats;
    });
  }

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  }) async {
    final chatRef = firestore.collection("chats").doc(chatId);

    final unreadMessages = await chatRef
        .collection("messages")
        .where("senderId", isNotEqualTo: currentUserId)
        .where("isRead", isEqualTo: false)
        .get();

    for (final doc in unreadMessages.docs) {
      await doc.reference.update({"isRead": true});
    }

    await chatRef.set({
      "unreadCounts": {currentUserId: 0}
    }, SetOptions(merge: true));
  }

  Future<void> markAllChatsAsReadForUser(String userId) async {
    final chatsSnapshot = await firestore
        .collection("chats")
        .where("participants", arrayContains: userId)
        .get();

    for (final doc in chatsSnapshot.docs) {
      await doc.reference.set({
        "unreadCounts": {userId: 0}
      }, SetOptions(merge: true));
    }
  }
}