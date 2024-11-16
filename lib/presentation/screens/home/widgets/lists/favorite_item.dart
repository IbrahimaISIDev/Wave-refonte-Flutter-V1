// lib/presentation/screens/home/widgets/lists/favorite_item.dart
import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/home/widgets/lists/favorite_avatar.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class FavoriteItem extends StatelessWidget {
  final int index;

  const FavoriteItem({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: HomeScreenStyles.defaultSpacing),
      decoration: HomeScreenStyles.favoriteItemDecoration,
      child: ListTile(
        contentPadding: HomeScreenStyles.listItemPadding,
        leading: FavoriteAvatar(imageUrl: "placeholder_$index"),
        title: Text(
          'Contact Favori ${index + 1}',
          style: HomeScreenStyles.favoriteTitleStyle,
        ),
        subtitle: Text(
          '7X XXX XX XX',
          style: HomeScreenStyles.favoriteSubtitleStyle,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.send),
          color: Theme.of(context).primaryColor,
          onPressed: () {},
        ),
      ),
    );
  }
}