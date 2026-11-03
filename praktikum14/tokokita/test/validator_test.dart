import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/screens/login_page.dart';

void main() {
  group('validasiEmail', () {
    test('menolak email kosong', () {
      expect(validasiEmail(''), 'Email wajib diisi');
    });
    test('menolak format yang salah', () {
      expect(validasiEmail('dimas'), 'Format email tidak valid');
      expect(validasiEmail('dimas@mail'), 'Format email tidak valid');
    });
    test('menerima format yang benar', () {
      expect(validasiEmail('dimas@mail.com'), isNull);
    });
  });

  group('validasiPassword', () {
    test('menolak password kosong', () {
      expect(validasiPassword(''), 'Password wajib diisi');
    });
    test('menolak password kurang dari 6 karakter', () {
      expect(validasiPassword('12345'), 'Password minimal 6 karakter');
    });
    test('menerima password 6 karakter atau lebih', () {
      expect(validasiPassword('123456'), isNull);
    });
  });
}
