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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
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
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.storefront,
                          size: 40, color: Colors.blue.shade700),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Masuk ke TokoKita',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Belanja jadi lebih mudah',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: validasiEmail,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
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
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
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
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(pesan,
                          style: TextStyle(
                              color: Colors.red.shade800, fontSize: 13)),
                    );
                  }),
                  Obx(() => FilledButton(
                        onPressed: auth.memproses.value ? null : _masuk,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue.shade700,
                        ),
                        child: auth.memproses.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
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
