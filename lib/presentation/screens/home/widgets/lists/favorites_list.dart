// lib/presentation/screens/home/widgets/lists/favorites_list.dart
import 'package:flutter/material.dart';
import 'package:wave_app/presentation/screens/home/widgets/lists/favorite_item.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: HomeScreenStyles.defaultSpacing,
      ),
      itemCount: 5,
      itemBuilder: (context, index) => FavoriteItem(index: index),
    );
  }
}