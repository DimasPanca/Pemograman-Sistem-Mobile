import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onPressed == null || widget.loading) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null && !widget.loading;
    final double offset = _pressed ? 0 : 4;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: enabled ? widget.onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, -offset / 2, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark,
                    offset: Offset(0, offset),
                    blurRadius: 0,
                  ),
                ]
              : const [],
        ),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: enabled ? AppColors.primary : AppColors.muted,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: AppColors.primaryDark, width: 1.2),
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(AppColors.surface),
                  ),
                )
              : Text(
                  widget.label.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.surface),
                ),
        ),
      ),
    );
  }
}
