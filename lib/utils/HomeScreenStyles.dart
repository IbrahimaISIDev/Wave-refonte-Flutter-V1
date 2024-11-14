// ignore: file_names
import 'package:flutter/material.dart';

class HomeScreenStyles {
  // Colors
  static Color getPrimaryColorWithOpacity(BuildContext context, double opacity) {
    return Theme.of(context).primaryColor.withOpacity(opacity);
  }

  // Gradients
  static BoxDecoration getHeaderGradient(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          getPrimaryColorWithOpacity(context, 0.9),
          getPrimaryColorWithOpacity(context, 0.6),
        ],
      ),
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // Text Styles
  static TextStyle get balanceTextStyle => const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get greetingTextStyle => TextStyle(
        color: Colors.white.withOpacity(0.95),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get quickActionLabelStyle => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get tabLabelStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );

  // Container Decorations
  static BoxDecoration getQuickActionDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    );
  }

  static BoxDecoration get tabContainerDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      );

  static BoxDecoration get transactionItemDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // Badge Decoration
  static BoxDecoration get badgeDecoration => BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      );

  static BoxDecoration getTransactionStatusDecoration(bool isCompleted) {
    Color color = isCompleted ? Colors.green : Colors.orange;
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    );
  }

  // Progress Indicator Style
  static BoxDecoration get progressIndicatorDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      );

  // Navigation Bar Theme
  static NavigationBarThemeData get navigationBarTheme => NavigationBarThemeData(
        indicatorColor: Colors.blue.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      );

  // Avatar Style
  static BoxDecoration get avatarDecoration => BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      );

  // Padding
  static const EdgeInsets defaultScreenPadding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 16.0,
  );

  static const EdgeInsets listItemPadding = EdgeInsets.all(12.0);

  // Spacings
  static const double defaultSpacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;

  // Sizes
  static const double avatarSize = 52.0;
  static const double iconSize = 24.0;
  static const double badgeSize = 16.0;

  // ignore: prefer_typing_uninitialized_variables
  static var favoriteSubtitleStyle;

  // Additional Decorations
  static BoxDecoration get modalContainerDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      );

  static BoxDecoration get scannerContainerDecoration => BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      );

  static BoxDecoration get favoriteItemDecoration => BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      );

  // Text Styles
  static TextStyle get qrCodeInstructionStyle => TextStyle(
        color: Colors.grey[700],
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get transactionTitleStyle => const TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get transactionSubtitleStyle => const TextStyle(
        color: Colors.black54,
        fontSize: 14,
      );

  static TextStyle get favoriteTitleStyle => const TextStyle(
        color: Colors.blueAccent,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  // Colors
  static Color get sentColor => Colors.red;
  static Color get receivedColor => Colors.green;

  // Transaction Amount Style Method
  static TextStyle getTransactionAmountStyle(bool isSent) {
    return TextStyle(
      color: isSent ? sentColor : receivedColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }
  
}