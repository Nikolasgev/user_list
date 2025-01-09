import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'user-${user.id}',
              child: Text('Email: ${user.email}'),
            ),
            Text('Phone: ${user.phone}'),
            Text('Website: ${user.website}'),
            Text(
                'Address: ${user.address.street}, ${user.address.suite}, ${user.address.city}, ${user.address.zipcode}'),
          ],
        ),
      ),
    );
  }
}
