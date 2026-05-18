import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileHeader extends StatelessWidget {
  final User? user;
  const ProfileHeader({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: user?.photoURL != null 
              ? NetworkImage(user!.photoURL!) 
              : const NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'Angelina',
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user?.phoneNumber ?? '(704) 555-0127',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user?.email ?? 'angelina@example.com',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_outlined, color: color),
          ),
        ],
      ),
    );
  }
}
