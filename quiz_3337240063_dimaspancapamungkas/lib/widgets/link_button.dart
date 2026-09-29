import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const LinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
            decoration: TextDecoration.underline,
            decorationThickness: 1.4,
          ),
        ),
      ),
    );
  }
}
