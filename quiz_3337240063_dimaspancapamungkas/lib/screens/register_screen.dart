import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/link_button.dart';
import '../widgets/primary_button.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  bool _agree = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui ketentuan terlebih dahulu.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Akun berhasil dibuat. Silakan masuk.'),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      stepLabel: 'DAFTAR · 02',
      title: 'Mulai\nbabak baru.',
      subtitle:
          'Buat akun untuk menyimpan catatan, ide, dan koleksi kecilmu di satu tempat.',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              label: 'Nama lengkap',
              hint: 'Nama yang ingin ditampilkan',
              icon: Icons.person_outline,
              controller: _nameCtrl,
              validator: (v) =>
                  Validators.notEmpty(v, field: 'Nama lengkap'),
            ),
            const SizedBox(height: AppSpacing.l),
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
              hint: 'Minimal 6 karakter',
              icon: Icons.lock_outline,
              controller: _passCtrl,
              obscure: true,
              validator: Validators.password,
            ),
            const SizedBox(height: AppSpacing.l),
            CustomTextField(
              label: 'Ulangi kata sandi',
              hint: 'Ketik ulang untuk memastikan',
              icon: Icons.lock_reset_outlined,
              controller: _confirmCtrl,
              obscure: true,
              validator: (v) =>
                  Validators.confirmPassword(v, _passCtrl.text),
            ),
            const SizedBox(height: AppSpacing.m),
            _AgreeCheckbox(
              value: _agree,
              onChanged: (v) => setState(() => _agree = v),
            ),
            const SizedBox(height: AppSpacing.l),
            PrimaryButton(
              label: 'Buat akun',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sudah punya akun?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: AppSpacing.xs),
          LinkButton(
            label: 'Masuk di sini',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _AgreeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AgreeCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? AppColors.accent : Colors.transparent,
                border: Border.all(color: AppColors.ink, width: 1.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? const Icon(Icons.check, size: 14, color: AppColors.surface)
                  : null,
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              'Saya menyetujui ketentuan layanan dan kebijakan privasi paperlog.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.ink,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
