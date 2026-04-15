import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Outfit  → títulos y headings
/// Manrope → texto general, labels, botones
class AppTextStyles {
  AppTextStyles._();

  // ── Outfit (títulos) ─────────────────────────────────────────────────────

  static TextStyle outfitDisplay({
    double size = 40,
    FontWeight weight = FontWeight.bold,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
  }) =>
      GoogleFonts.outfit(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle outfitHeading({
    double size = 34,
    FontWeight weight = FontWeight.bold,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
  }) =>
      GoogleFonts.outfit(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  // ── Manrope (texto general) ───────────────────────────────────────────────

  static TextStyle manropeBody({
    double size = 14,
    FontWeight weight = FontWeight.normal,
    Color color = AppColors.textPrimary,
  }) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  static TextStyle manropeLabel({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.textPrimary,
  }) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  static TextStyle manropeButton({
    double size = 16,
    FontWeight weight = FontWeight.w600,
    Color color = Colors.white,
  }) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: 0.2,
      );

  static TextStyle manropeHint({
    double size = 14,
    Color color = AppColors.textHint,
  }) =>
      GoogleFonts.manrope(
        fontSize: size,
        color: color,
      );

  static TextStyle manropeCaption({
    double size = 13,
    Color color = AppColors.textCaption,
  }) =>
      GoogleFonts.manrope(
        fontSize: size,
        color: color,
      );
}
