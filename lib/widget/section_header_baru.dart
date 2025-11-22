import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/screens/film_list_screen.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onSeeAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAllPressed != null)
            GestureDetector(
              onTap: onSeeAllPressed,
              child: Text(
                'Lihat Semua',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}