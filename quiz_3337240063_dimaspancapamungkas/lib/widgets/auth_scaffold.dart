import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthScaffold extends StatelessWidget {
  final String stepLabel;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final bool showBack;

  const AuthScaffold({
    super.key,
    required this.stepLabel,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            const _CornerDecoration(),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.m,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical -
                      AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(stepLabel: stepLabel, showBack: showBack),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    child,
                    const SizedBox(height: AppSpacing.l),
                    if (footer != null) footer!,
                    const SizedBox(height: AppSpacing.m),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String stepLabel;
  final bool showBack;

  const _Header({required this.stepLabel, required this.showBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          _CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          )
        else
          const _Logo(),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.ink, width: 1),
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: Text(
            stepLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.ink,
                ),
          ),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: const Center(
            child: Text(
              'p',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppColors.surface,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Text(
          'paperlog',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.ink, width: 1.2),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: Icon(icon, size: 20, color: AppColors.ink),
      ),
    );
  }
}

class _CornerDecoration extends StatelessWidget {
  const _CornerDecoration();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _CornerPainter(),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint line = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double margin = 14;
    const double armLength = 26;
    for (final Offset origin in <Offset>[
      const Offset(margin, margin),
      Offset(size.width - margin, margin),
      Offset(margin, size.height - margin),
      Offset(size.width - margin, size.height - margin),
    ]) {
      final double dx = origin.dx < size.width / 2 ? 1 : -1;
      final double dy = origin.dy < size.height / 2 ? 1 : -1;
      canvas.drawLine(origin, origin.translate(armLength * dx, 0), line);
      canvas.drawLine(origin, origin.translate(0, armLength * dy), line);
    }

    final Paint dot = Paint()..color = AppColors.accent;
    canvas.drawCircle(Offset(size.width - margin - 6, margin + 6), 3, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
