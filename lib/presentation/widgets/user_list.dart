import 'package:flutter/material.dart';
import 'package:tz01/presentation/pages/user_detail_page.dart';

import '../../domain/entities/user.dart';

class UserList extends StatelessWidget {
  final List<User> users;

  const UserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Hero(
            tag: 'user-${user.id}',
            child: Text(user.name),
          ),
          subtitle: Text(user.email),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailPage(user: user),
              ),
            );
          },
        );
      },
    );
  }
}
