import 'package:buhairi_academy_application/Models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get currentUserId => auth.currentUser!.uid;

  Future<void> createGroup({
    required String groupName,
    required List<String> memberIds,
    required List<String> memberNames,
  }) async {
    final doc = firestore.collection("groups").doc();

    final group = GroupModel(
      groupId: doc.id,
      groupName: groupName.trim(),
      createdBy: currentUserId,
      memberIds: memberIds,
      memberNames: memberNames,
      createdAt: Timestamp.now(),
    );

    await doc.set(group.toMap());
  }

  Stream<List<GroupModel>> getCoachGroups() {
    return firestore
        .collection("groups")
        .where("createdBy", isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      final groups = snapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data()))
          .toList();

      groups.sort((a, b) {
        final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bTime.compareTo(aTime);
      });

      return groups;
    });
  }

  Future<void> deleteGroup(String groupId) async {
    await firestore.collection("groups").doc(groupId).delete();
  }
}