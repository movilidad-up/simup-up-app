import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:simup_up/views/components/nav-button.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late final List<GlobalKey> _navKeys;
  bool isTourCompleted = true;

  @override
  void initState() {
    super.initState();
    _navKeys = List.generate(4, (_) => GlobalKey());
    _checkTourCompletion();
  }

  Future<void> _checkTourCompletion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isTourCompleted = prefs.getBool('tourCompleted') ?? false;
      if (!isTourCompleted) {
        _startShowcase();
      }
    } catch (e) {
      print('Error checking tour completion: $e');
    }
  }

  void _startShowcase() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase(_navKeys);
    });
  }

  Future<void> _updateTourCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tourCompleted', true);
  }

  void _onShowcaseInteraction(int index) {
    if (index == 3) {
      _updateTourCompletion();
    }
  }

  Showcase _buildShowcase({
    required GlobalKey key,
    required String title,
    required String description,
    required IconData icon,
    required int index,
  }) {
    return Showcase(
      key: key,
      title: title,
      description: description,
      disposeOnTap: true,
      onTargetClick: () => _onShowcaseInteraction(index),
      onBarrierClick: () => _onShowcaseInteraction(index),
      onToolTipClick: () => _onShowcaseInteraction(index),
      child: NavButton(
        icon: icon,
        selected: widget.currentIndex == index,
      ),
      titleTextStyle: _textStyle(context, Theme.of(context).colorScheme.onSurface),
      descTextStyle: _textStyle(context, Theme.of(context).colorScheme.tertiary, fontSize: 14.0),
      tooltipBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      tooltipBorderRadius: BorderRadius.circular(24.0),
      tooltipPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      targetPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      targetBorderRadius: BorderRadius.circular(24.0),
      scaleAnimationCurve: Curves.ease,
    );
  }

  TextStyle _textStyle(BuildContext context, Color color, {double fontSize = 16.0}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      fontFamily: 'Inter',
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(64.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildShowcase(
              key: _navKeys[0],
              title: AppLocalizations.of(context)!.tourHome,
              description: AppLocalizations.of(context)!.tourHomeDescription,
              icon: Icons.home_rounded,
              index: 0,
            ),
            _buildShowcase(
              key: _navKeys[1],
              title: AppLocalizations.of(context)!.tourRoutes,
              description: AppLocalizations.of(context)!.tourRoutesDescription,
              icon: Icons.route_rounded,
              index: 1,
            ),
            _buildShowcase(
              key: _navKeys[2],
              title: AppLocalizations.of(context)!.tourReminders,
              description: AppLocalizations.of(context)!.tourRemindersDescription,
              icon: Icons.notifications_rounded,
              index: 2,
            ),
            _buildShowcase(
              key: _navKeys[3],
              title: AppLocalizations.of(context)!.tourMap,
              description: AppLocalizations.of(context)!.tourMapDescription,
              icon: Icons.map_rounded,
              index: 3,
            ),
          ],
        ),
      ),
    );
  }
}
