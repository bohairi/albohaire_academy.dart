import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String senderName;
  final String text;
  final Timestamp timestamp;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "senderId": senderId,
      "senderName": senderName,
      "text": text,
      "timestamp": timestamp,
      "isRead": isRead,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map["messageId"]?.toString() ?? "",
      senderId: map["senderId"]?.toString() ?? "",
      senderName: map["senderName"]?.toString() ?? "",
      text: map["text"]?.toString() ?? "",
      timestamp: map["timestamp"] is Timestamp
          ? map["timestamp"]
          : Timestamp.now(),
      isRead: map["isRead"] ?? false,
    );
  }
}