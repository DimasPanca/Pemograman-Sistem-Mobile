class Validators {
  static String? email(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Email tidak boleh kosong';
    final RegExp regex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w\-.]+$');
    if (!regex.hasMatch(v)) return 'Format email belum benar';
    return null;
  }

  static String? password(String? value) {
    final String v = value ?? '';
    if (v.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (v.length < 6) return 'Minimal 6 karakter';
    return null;
  }

  static String? notEmpty(String? value, {String field = 'Kolom ini'}) {
    if ((value ?? '').trim().isEmpty) return '$field tidak boleh kosong';
    return null;
  }

  static String? confirmPassword(String? value, String other) {
    if ((value ?? '').isEmpty) return 'Konfirmasi kata sandi';
    if (value != other) return 'Kata sandi tidak cocok';
    return null;
  }
}
