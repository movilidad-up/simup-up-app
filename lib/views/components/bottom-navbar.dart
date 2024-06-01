import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/components/nav-button.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(64.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => widget.onTap(0),
              child: NavButton(
                icon: Icons.home_rounded,
                selected: widget.currentIndex == 0,
              ),
            ),
            GestureDetector(
              onTap: () => widget.onTap(1),
              child: NavButton(
                icon: Icons.route_rounded,
                selected: widget.currentIndex == 1,
              ),
            ),
            GestureDetector(
              onTap: () => widget.onTap(2),
              child: NavButton(
                icon: Icons.notifications_rounded,
                selected: widget.currentIndex == 2,
              ),
            ),
            GestureDetector(
              onTap: () => widget.onTap(3),
              child: NavButton(
                icon: Icons.map_rounded,
                selected: widget.currentIndex == 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}