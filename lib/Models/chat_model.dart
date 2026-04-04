import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatId;
  final String type;
  final List<String> participants;
  final List<String> participantNames;
  final Map<String, dynamic> unreadCounts;
  final String lastMessage;
  final Timestamp? lastMessageTime;
  final String lastSenderId;
  final Timestamp? createdAt;

  ChatModel({
    required this.chatId,
    required this.type,
    required this.participants,
    required this.participantNames,
    required this.unreadCounts,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastSenderId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
      "type": type,
      "participants": participants,
      "participantNames": participantNames,
      "unreadCounts": unreadCounts,
      "lastMessage": lastMessage,
      "lastMessageTime": lastMessageTime,
      "lastSenderId": lastSenderId,
      "createdAt": createdAt,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map["chatId"]?.toString() ?? "",
      type: map["type"]?.toString() ?? "private",
      participants: List<String>.from(map["participants"] ?? []),
      participantNames: List<String>.from(map["participantNames"] ?? []),
      unreadCounts: Map<String, dynamic>.from(map["unreadCounts"] ?? {}),
      lastMessage: map["lastMessage"]?.toString() ?? "",
      lastMessageTime: map["lastMessageTime"],
      lastSenderId: map["lastSenderId"]?.toString() ?? "",
      createdAt: map["createdAt"],
    );
  }
}