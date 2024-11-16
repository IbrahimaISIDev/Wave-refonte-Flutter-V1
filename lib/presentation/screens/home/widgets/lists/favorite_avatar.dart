// lib/presentation/screens/home/widgets/lists/favorite_avatar.dart
import 'package:flutter/material.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class FavoriteAvatar extends StatelessWidget {
  final String imageUrl;

  const FavoriteAvatar({
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: HomeScreenStyles.avatarDecoration,
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: HomeScreenStyles.avatarSize / 2,
      ),
    );
  }
}