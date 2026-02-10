import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:univtime/widgets/main_navigation.dart';
import 'package:univtime/utils/theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildLogoSection(),
              const Spacer(flex: 3),
              _buildContentSection(context),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/icons/grad_cap.png',
            height: 70,
            width: 70,
            colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'UnivTime',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your Complete Student Companion',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to access your courses, schedule, and tasks',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          _buildGoogleButton(context),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.divider)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or',
                  style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
                ),
              ),
              Expanded(child: Divider(color: AppColors.divider)),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: Text(
              'Continue as Guest',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: AppColors.divider),
          elevation: 0,
        ),
        icon: const Icon(FontAwesomeIcons.google, size: 18, color: AppColors.primary),
        label: const Text(
          'Continue with Google',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigation()),
          );
        },
      ),
    );
  }
}
