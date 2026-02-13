import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/onboarding/welcome_screen.dart';
import 'ui/screens/onboarding/period_length_screen.dart';
import 'ui/screens/onboarding/cycle_length_screen.dart';
import 'ui/screens/onboarding/last_period_screen.dart';
import 'ui/screens/onboarding/success_screen.dart';
import 'ui/screens/tabs/tabs_screen.dart';
import 'ui/screens/edit_period_screen.dart';
import 'ui/screens/health_tracking_screen.dart';
import 'ui/screens/info/prediction_info_screen.dart';
import 'ui/screens/info/cycle_length_info_screen.dart';
import 'ui/screens/info/period_length_info_screen.dart';
import 'ui/screens/info/late_period_info_screen.dart';
import 'ui/screens/info/cycle_phase_details_screen.dart';
import 'ui/screens/settings/about_screen.dart';
import 'ui/screens/settings/privacy_policy_screen.dart';
import 'ui/screens/settings/reminders_screen.dart';
import 'ui/screens/settings/app_lock_screen.dart';
import 'ui/screens/settings/calendar_view_settings_screen.dart';
import 'ui/screens/cycle_details_screen.dart';
import 'providers/database_provider.dart';
import 'providers/service_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('te'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/init',
  routes: [
    GoRoute(
      path: '/init',
      builder: (context, state) => const AppInitScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const TabsScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const WelcomeScreen(),
      routes: [
        GoRoute(
          path: 'period-length',
          builder: (context, state) => const PeriodLengthScreen(),
        ),
        GoRoute(
          path: 'cycle-length',
          builder: (context, state) => const CycleLengthScreen(),
        ),
        GoRoute(
          path: 'last-period',
          builder: (context, state) => const LastPeriodScreen(),
        ),
        GoRoute(
          path: 'success',
          builder: (context, state) => const SuccessScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/edit-period',
      builder: (context, state) => const EditPeriodScreen(),
    ),
    GoRoute(
      path: '/health-tracking',
      builder: (context, state) {
        final date = state.uri.queryParameters['date'];
        final scrollTo = state.uri.queryParameters['scrollTo'];
        return HealthTrackingScreen(initialDate: date, scrollTo: scrollTo);
      },
    ),
    GoRoute(
      path: '/cycle-details',
      builder: (context, state) {
        final startDate = state.uri.queryParameters['startDate']!;
        final endDate = state.uri.queryParameters['endDate']!;
        final cycleLength = int.parse(state.uri.queryParameters['cycleLength']!);
        final periodLength = int.parse(state.uri.queryParameters['periodLength']!);
        final isCurrentCycle = state.uri.queryParameters['isCurrentCycle'] == 'true';
        return CycleDetailsScreen(
          startDate: startDate,
          endDate: endDate,
          cycleLength: cycleLength,
          periodLength: periodLength,
          isCurrentCycle: isCurrentCycle,
        );
      },
    ),
    GoRoute(path: '/info/prediction-info', builder: (context, state) => const PredictionInfoScreen()),
    GoRoute(path: '/info/cycle-length-info', builder: (context, state) => const CycleLengthInfoScreen()),
    GoRoute(path: '/info/period-length-info', builder: (context, state) => const PeriodLengthInfoScreen()),
    GoRoute(path: '/info/late-period-info', builder: (context, state) => const LatePeriodInfoScreen()),
    GoRoute(
      path: '/info/cycle-phase-details',
      builder: (context, state) {
        final cycleDay = int.parse(state.uri.queryParameters['cycleDay']!);
        final averageCycleLength = int.parse(state.uri.queryParameters['averageCycleLength']!);
        return CyclePhaseDetailsScreen(cycleDay: cycleDay, averageCycleLength: averageCycleLength);
      },
    ),
    GoRoute(path: '/settings/about', builder: (context, state) => const AboutScreen()),
    GoRoute(path: '/settings/privacy-policy', builder: (context, state) => const PrivacyPolicyScreen()),
    GoRoute(path: '/settings/reminders', builder: (context, state) => const RemindersScreen()),
    GoRoute(path: '/settings/app-lock', builder: (context, state) => const AppLockScreen()),
    GoRoute(path: '/settings/calendar-view', builder: (context, state) => const CalendarViewSettingsScreen()),
  ],
);

class AppInitScreen extends ConsumerStatefulWidget {
  const AppInitScreen({super.key});

  @override
  ConsumerState<AppInitScreen> createState() => _AppInitScreenState();
}

class _AppInitScreenState extends ConsumerState<AppInitScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final authService = ref.read(authServiceProvider);

    // Check lock
    final isLocked = await authService.isLockEnabled();
    if (isLocked) {
      final success = await authService.authenticate();
      if (!success) {
        // Handle auth failure (stay on init or show error)
        return;
      }
    }

    final onboardingCompleted = await settingsRepo.getSetting('onboardingCompleted');
    if (onboardingCompleted == 'true') {
      if (mounted) context.go('/');
    } else {
      if (mounted) context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cicla',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
