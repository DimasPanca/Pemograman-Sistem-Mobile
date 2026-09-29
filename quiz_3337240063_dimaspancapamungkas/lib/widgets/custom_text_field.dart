import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.icon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focus = FocusNode();
  bool _hidden = true;

  @override
  void initState() {
    super.initState();
    _hidden = widget.obscure;
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool focused = _focus.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: focused ? AppColors.primary : AppColors.muted,
              ),
        ),
        const SizedBox(height: AppSpacing.s),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(
                color: focused ? AppColors.primary : AppColors.divider,
                width: focused ? 2.2 : 1.4,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon,
                    size: 18,
                    color: focused ? AppColors.primary : AppColors.muted),
                const SizedBox(width: AppSpacing.s),
              ],
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focus,
                  obscureText: _hidden && widget.obscure,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  style: Theme.of(context).textTheme.bodyLarge,
                  cursorColor: AppColors.accent,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.muted.withOpacity(0.7)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                    errorStyle: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              if (widget.obscure)
                GestureDetector(
                  onTap: () => setState(() => _hidden = !_hidden),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.muted,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
