import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'home_tab.dart';
import 'calendar_tab.dart';
import 'stats_tab.dart';
import 'settings_tab.dart';

class TabsScreen extends StatefulWidget {
  final int initialIndex;
  const TabsScreen({super.key, this.initialIndex = 0});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _tabs = [
    const HomeTab(),
    const CalendarTab(),
    const StatsTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: colors.surface,
          selectedItemColor: colors.primary,
          unselectedItemColor: colors.neutral200,
          selectedLabelStyle: const TextStyle(fontSize: 11.5, letterSpacing: 0.2),
          unselectedLabelStyle: const TextStyle(fontSize: 11.5, letterSpacing: 0.2),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.access_time_outlined),
              activeIcon: const Icon(Icons.access_time_filled),
              label: 'common.navigation.today'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              activeIcon: const Icon(Icons.calendar_month),
              label: 'common.navigation.calendar'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_outlined),
              activeIcon: const Icon(Icons.bar_chart),
              label: 'common.navigation.stats'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: 'common.navigation.settings'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
