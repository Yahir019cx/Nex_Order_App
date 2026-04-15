import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Paleta base ───────────────────────────────────────────────────────────
  static const Color background   = Color(0xFF151515); // fondo pantalla
  static const Color surface      = Color(0xFF1F1F1F); // panel brand (izq)
  static const Color formPanel    = Color(0xFF2A2725); // panel form  (der)
  static const Color inputFill    = Color(0xFF282624); // fondo inputs
  static const Color accent       = Color(0xFFA38162); // botón / focus

  // ── Texto ─────────────────────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFFEFECE9); // títulos / labels
  static const Color textMuted    = Color(0xFF9E9A96); // subtítulos
  static const Color textHint     = Color(0xFF6B6560); // placeholder
  static const Color textCaption  = Color(0xFF57534E); // footer

  // ── Bordes ────────────────────────────────────────────────────────────────
  static const Color border       = Color(0xFF3A3835); // borde input normal
}
