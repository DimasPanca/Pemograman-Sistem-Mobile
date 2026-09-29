import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/link_button.dart';
import '../widgets/primary_button.dart';
import '../utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      stepLabel: 'PULIH · 03',
      title: _sent ? 'Cek kotak\nmasukmu.' : 'Lupa\nkata sandi?',
      subtitle: _sent
          ? 'Kami sudah mengirim tautan pemulihan ke ${_emailCtrl.text.trim()}. Ikuti tautannya untuk membuat sandi baru.'
          : 'Tulis email akunmu. Kami akan mengirim tautan singkat untuk mengatur ulang kata sandi.',
      showBack: true,
      child: _sent ? _SuccessCard(email: _emailCtrl.text.trim()) : _buildForm(),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _sent ? 'Belum menerima email?' : 'Ingat sandi lagi?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: AppSpacing.xs),
          LinkButton(
            label: _sent ? 'Kirim ulang' : 'Kembali masuk',
            onPressed: () {
              if (_sent) {
                _submit();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: 'Email terdaftar',
            hint: 'nama@email.com',
            icon: Icons.mail_outline,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: AppSpacing.l),
          PrimaryButton(
            label: 'Kirim tautan pemulihan',
            loading: _loading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.m),
          const _HelperNote(),
        ],
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final String email;

  const _SuccessCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.ink, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: const Icon(Icons.mark_email_read_outlined,
                    color: AppColors.surface),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Text(
                  'Tautan terkirim',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Dikirim ke $email. Tautan berlaku selama 15 menit sejak diterima.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _HelperNote extends StatelessWidget {
  const _HelperNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.muted),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              'Tautan hanya berlaku 15 menit. Cek juga folder promosi atau spam bila belum muncul.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
