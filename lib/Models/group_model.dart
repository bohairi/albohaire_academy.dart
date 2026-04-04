import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId;
  final String groupName;
  final String createdBy;
  final List<String> memberIds;
  final List<String> memberNames;
  final Timestamp? createdAt;

  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.createdBy,
    required this.memberIds,
    required this.memberNames,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "groupId": groupId,
      "groupName": groupName,
      "createdBy": createdBy,
      "memberIds": memberIds,
      "memberNames": memberNames,
      "createdAt": createdAt,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map["groupId"]?.toString() ?? "",
      groupName: map["groupName"]?.toString() ?? "",
      createdBy: map["createdBy"]?.toString() ?? "",
      memberIds: List<String>.from(map["memberIds"] ?? []),
      memberNames: List<String>.from(map["memberNames"] ?? []),
      createdAt: map["createdAt"],
    );
  }
}