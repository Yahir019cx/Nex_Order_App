import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/Auth/login_screen.dart';
import 'features/dashboard/app_shell.dart';

void main() {
  runApp(const NexOrderApp());
}

class NexOrderApp extends StatelessWidget {
  const NexOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexOrder Pro',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const LoginScreen(),
      routes: {
        '/dashboard': (_) => const AppShell(),
      },
    );
  }

  ThemeData _buildTheme() {
    const accent     = AppColors.accent;
    const inputFill  = AppColors.inputFill;
    const textMuted  = AppColors.textMuted;

    // Overlay suave basado en el accent para ripples
    final accentOverlay  = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed))  return accent.withValues(alpha: 0.14);
      if (states.contains(WidgetState.hovered))  return accent.withValues(alpha: 0.06);
      if (states.contains(WidgetState.focused))  return accent.withValues(alpha: 0.10);
      return Colors.transparent;
    });

    final neutralOverlay = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed))  return textMuted.withValues(alpha: 0.12);
      if (states.contains(WidgetState.hovered))  return textMuted.withValues(alpha: 0.05);
      if (states.contains(WidgetState.focused))  return textMuted.withValues(alpha: 0.08);
      return Colors.transparent;
    });

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary:   accent,
        secondary: accent,
        surface:   AppColors.surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      splashFactory: InkRipple.splashFactory,
      splashColor:   accent.withValues(alpha: 0.12),
      highlightColor: Colors.transparent,
      focusColor:     accent.withValues(alpha: 0.08),
      hoverColor:     accent.withValues(alpha: 0.05),

      // ── ElevatedButton ────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return inputFill;
            }
            return accent;
          }),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          overlayColor: accentOverlay,
          elevation: const WidgetStatePropertyAll(0),
          splashFactory: InkRipple.splashFactory,
        ),
      ),

      // ── TextButton ────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(textMuted),
          overlayColor: neutralOverlay,
          splashFactory: InkRipple.splashFactory,
        ),
      ),

      // ── OutlinedButton ────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(accent),
          overlayColor: accentOverlay,
          side: WidgetStatePropertyAll(
              BorderSide(color: accent.withValues(alpha: 0.5))),
          splashFactory: InkRipple.splashFactory,
        ),
      ),

      // ── DropdownMenu ─────────────────────────────────────────────────────
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xFF1E1C1A)),
        ),
      ),

      // ── TextField cursor ─────────────────────────────────────────────────
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: accent.withValues(alpha: 0.3),
        selectionHandleColor: accent,
      ),
    );
  }
}
