import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import 'login_page.dart';
import 'main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController auth = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _ulangi = TextEditingController();
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
    _ulangi.dispose();
    super.dispose();
  }

  Future<void> _daftar() async {
    if (!_formKey.currentState!.validate()) return;
    final berhasil = await auth.daftar(_email.text, _password.text);
    if (berhasil) Get.offAll(() => const MainPage());
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final skema = tema.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Buat akun TokoKita', style: tema.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('Isi email dan password untuk mulai berbelanja.',
                    style: TextStyle(color: skema.onSurfaceVariant)),
                const SizedBox(height: 20),
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
                      onPressed: () => setState(() => _sembunyi = !_sembunyi),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ulangi,
                  obscureText: _sembunyi,
                  validator: (v) =>
                      v != _password.text ? 'Password tidak sama' : null,
                  decoration: const InputDecoration(
                    labelText: 'Ulangi password',
                    prefixIcon: Icon(Icons.lock_outline),
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
                      border:
                          Border.all(color: skema.error.withValues(alpha: 0.4)),
                    ),
                    child: Text(pesan,
                        style: TextStyle(color: skema.error, fontSize: 13)),
                  );
                }),
                Obx(() => FilledButton(
                      onPressed: auth.memproses.value ? null : _daftar,
                      child: auth.memproses.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: skema.onPrimary))
                          : const Text('Daftar'),
                    )),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.off(() => const LoginPage()),
                  child: const Text('Sudah punya akun? Masuk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
