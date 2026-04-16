import 'package:flutter/material.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';
import 'login_input_field.dart';

class LoginFormPanel extends StatelessWidget {
  const LoginFormPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Iniciar sesión',
            style: AppTextStyles.outfitHeading(
              size: 34,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa tus credenciales para acceder',
            style: AppTextStyles.manropeBody(color: AppColors.textMuted),
          ),
          const SizedBox(height: 36),
          Text('Usuario', style: AppTextStyles.manropeLabel()),
          const SizedBox(height: 8),
          const LoginInputField(hint: 'Ingresa tu usuario'),
          const SizedBox(height: 22),
          Text('Contraseña', style: AppTextStyles.manropeLabel()),
          const SizedBox(height: 8),
          const LoginInputField(
            hint: 'Ingresa tu contraseña',
            isPassword: true,
          ),
          const Spacer(),
          const _SubmitButton(),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text('Iniciar sesión', style: AppTextStyles.manropeButton()),
      ),
    );
  }
}
