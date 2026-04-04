import 'package:buhairi_academy_application/Models/group_model.dart';
import 'package:buhairi_academy_application/Screens/coach_system/create_group_screen.dart';
import 'package:buhairi_academy_application/Services/group_service.dart';
import 'package:flutter/material.dart';

class GroupListScreen extends StatelessWidget {
  GroupListScreen({super.key});

  final GroupService groupService = GroupService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Groups"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateGroupScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<GroupModel>>(
        stream: groupService.getCoachGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final groups = snapshot.data ?? [];

          if (groups.isEmpty) {
            return const Center(
              child: Text("No groups yet"),
            );
          }

          return ListView.separated(
            itemCount: groups.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final group = groups[index];

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.groups),
                ),
                title: Text(group.groupName),
                subtitle: Text("${group.memberIds.length} members"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await groupService.deleteGroup(group.groupId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}