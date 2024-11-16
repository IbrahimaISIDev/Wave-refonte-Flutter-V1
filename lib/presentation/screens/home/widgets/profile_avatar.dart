// lib/presentation/screens/home/widgets/profile_avatar.dart
import 'package:flutter/material.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final VoidCallback onTap;

  const ProfileAvatar({
    required this.photoUrl,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: HomeScreenStyles.avatarDecoration,
          child: CircleAvatar(
            radius: HomeScreenStyles.avatarSize / 2,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}