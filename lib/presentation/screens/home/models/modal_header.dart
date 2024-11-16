// lib/presentation/screens/home/widgets/modals/modal_header.dart
import 'package:flutter/material.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class ModalHeader extends StatelessWidget {
  final String title;

  const ModalHeader({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      decoration: HomeScreenStyles.modalHeaderDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}