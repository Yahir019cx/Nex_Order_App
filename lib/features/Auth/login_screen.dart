import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/login_brand_panel.dart';
import 'widgets/login_form_panel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1000,
                maxHeight: 560,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: const Row(
                  children: [
                    Expanded(child: LoginBrandPanel()),
                    Expanded(child: LoginFormPanel()),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Text(
              'NexDevCode © 2026',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textCaption,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
