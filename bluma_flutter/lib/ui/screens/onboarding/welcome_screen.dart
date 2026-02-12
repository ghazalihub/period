import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/illustrations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.panel,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: -20,
            child: Shape1(color: colors.shape1, width: 325, height: 325),
          ),
          Positioned(
            bottom: -80,
            right: -100,
            child: Shape2(color: colors.shape2, width: 381, height: 291),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/bluma-logo.png',
                          width: 200,
                          height: 55,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'onboarding.welcome.title'.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: colors.textPrimary,
                                fontSize: 33,
                                height: 40 / 33,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'onboarding.welcome.subtitle'.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colors.textSecondary,
                                fontSize: 20,
                                height: 28 / 20,
                              ),
                        ),
                        const SizedBox(height: 34),
                        _buildBadge(
                          context,
                          Icons.lock_outline,
                          'onboarding.welcome.badgeStorage'.tr(),
                        ),
                        const SizedBox(height: 10),
                        _buildBadge(
                          context,
                          Icons.block_outlined,
                          'onboarding.welcome.badgeNoTracking'.tr(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomButton(
                    title: 'common.buttons.getStarted'.tr(),
                    fullWidth: true,
                    onPress: () => context.push('/onboarding/period-length'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, IconData icon, String text) {
    final colors = context.colors;
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Icon(icon, color: colors.accentPink, size: 24),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                  fontSize: 19,
                  height: 24 / 19,
                ),
          ),
        ),
      ],
    );
  }
}
