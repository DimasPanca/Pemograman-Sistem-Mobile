import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import 'main_page.dart';
import 'register_page.dart';

final RegExp _polaEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? validasiEmail(String? v) {
  final teks = (v ?? '').trim();
  if (teks.isEmpty) return 'Email wajib diisi';
  if (!_polaEmail.hasMatch(teks)) return 'Format email tidak valid';
  return null;
}

String? validasiPassword(String? v) {
  final teks = v ?? '';
  if (teks.isEmpty) return 'Password wajib diisi';
  if (teks.length < 6) return 'Password minimal 6 karakter';
  return null;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController auth = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _sembunyi = true;

  @override
  void initState() {
    super.initState();
    auth.pesanError.value = null;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    if (!_formKey.currentState!.validate()) return;
    final berhasil = await auth.masuk(_email.text, _password.text);
    if (berhasil) Get.offAll(() => const MainPage());
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final skema = tema.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: skema.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.storefront,
                          size: 40, color: skema.primary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Masuk ke TokoKita',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('Belanja jadi lebih mudah',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: skema.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: validasiEmail,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    obscureText: _sembunyi,
                    validator: validasiPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_sembunyi
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setState(() => _sembunyi = !_sembunyi),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final pesan = auth.pesanError.value;
                    if (pesan == null) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: skema.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: skema.error.withValues(alpha: 0.4)),
                      ),
                      child: Text(pesan,
                          style: TextStyle(color: skema.error, fontSize: 13)),
                    );
                  }),
                  Obx(() => FilledButton(
                        onPressed: auth.memproses.value ? null : _masuk,
                        child: auth.memproses.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: skema.onPrimary))
                            : const Text('Masuk'),
                      )),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Get.to(() => const RegisterPage()),
                    child: const Text('Belum punya akun? Daftar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
