import 'package:flutter/material.dart';

/// Warna tambahan TokoKita yang tidak tersedia pada ColorScheme bawaan Material.
class TokoTema extends ThemeExtension<TokoTema> {
  final Color harga;
  final Color sukses;
  final Color peringatan;
  final Color netral;
  final Color netralMuda;

  const TokoTema({
    required this.harga,
    required this.sukses,
    required this.peringatan,
    required this.netral,
    required this.netralMuda,
  });

  static TokoTema of(BuildContext context) =>
      Theme.of(context).extension<TokoTema>()!;

  @override
  TokoTema copyWith({
    Color? harga,
    Color? sukses,
    Color? peringatan,
    Color? netral,
    Color? netralMuda,
  }) {
    return TokoTema(
      harga: harga ?? this.harga,
      sukses: sukses ?? this.sukses,
      peringatan: peringatan ?? this.peringatan,
      netral: netral ?? this.netral,
      netralMuda: netralMuda ?? this.netralMuda,
    );
  }

  @override
  TokoTema lerp(ThemeExtension<TokoTema>? other, double t) {
    if (other is! TokoTema) return this;
    return TokoTema(
      harga: Color.lerp(harga, other.harga, t)!,
      sukses: Color.lerp(sukses, other.sukses, t)!,
      peringatan: Color.lerp(peringatan, other.peringatan, t)!,
      netral: Color.lerp(netral, other.netral, t)!,
      netralMuda: Color.lerp(netralMuda, other.netralMuda, t)!,
    );
  }
}

ThemeData buatTema() {
  const biruToko = Color(0xFF1976D2);
  final skema = ColorScheme.fromSeed(seedColor: biruToko).copyWith(
    primary: biruToko,
    onPrimary: Colors.white,
    surface: Colors.white,
    error: const Color(0xFFFF5252),
    onError: Colors.white,
    onSurfaceVariant: Colors.black54,
    outline: Colors.black38,
    outlineVariant: const Color(0xFFE1E5EC),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: skema,
    scaffoldBackgroundColor: const Color(0xFFF3F5F9),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(fontSize: 12),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: skema.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      scrolledUnderElevation: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: skema.primary,
        foregroundColor: skema.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: skema.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: skema.primary,
      unselectedItemColor: Colors.black45,
    ),
    extensions: [
      TokoTema(
        harga: const Color(0xFFFF5252),
        sukses: Colors.green,
        peringatan: Colors.orange,
        netral: Colors.blueGrey,
        netralMuda: Colors.blueGrey.shade50,
      ),
    ],
  );
}
