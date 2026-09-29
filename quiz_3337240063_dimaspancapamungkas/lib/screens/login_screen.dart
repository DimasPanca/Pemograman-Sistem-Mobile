import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/link_button.dart';
import '../widgets/primary_button.dart';
import '../utils/validators.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _remember = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil masuk. Selamat datang kembali!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _goRegister() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RegisterScreen()),
    );
  }

  void _goForgot() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      stepLabel: 'MASUK · 01',
      title: 'Halo lagi.\nSenang bertemu.',
      subtitle:
          'Masuk untuk melanjutkan catatan harian dan ide-ide yang tersimpan.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              label: 'Email',
              hint: 'nama@email.com',
              icon: Icons.alternate_email,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSpacing.l),
            CustomTextField(
              label: 'Kata sandi',
              hint: 'Tulis kata sandi',
              icon: Icons.lock_outline,
              controller: _passCtrl,
              obscure: true,
              validator: Validators.password,
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                _RememberSwitch(
                  value: _remember,
                  onChanged: (v) => setState(() => _remember = v),
                ),
                const Spacer(),
                LinkButton(label: 'Lupa sandi?', onPressed: _goForgot),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            PrimaryButton(
              label: 'Masuk sekarang',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
      footer: Column(
        children: [
          const _OrDivider(),
          const SizedBox(height: AppSpacing.m),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum punya akun?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: AppSpacing.xs),
              LinkButton(label: 'Buat akun baru', onPressed: _goRegister),
            ],
          ),
        ],
      ),
    );
  }
}

class _RememberSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RememberSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColors.primary : Colors.transparent,
              border: Border.all(color: AppColors.ink, width: 1.4),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(Icons.check, size: 14, color: AppColors.surface)
                : null,
          ),
          const SizedBox(width: AppSpacing.s),
          Text(
            'Ingat saya',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.ink,
                ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Text(
            'ATAU',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider, height: 1)),
      ],
    );
  }
}
