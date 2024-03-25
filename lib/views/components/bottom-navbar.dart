import 'package:flutter/material.dart';
import 'package:simup_up/views/components/nav-button.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavbar({Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);

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
              onTap: () => onTap(0),
              child: NavButton(
                icon: Icons.home_rounded,
                selected: currentIndex == 0,
              ),
            ),
            GestureDetector(
              onTap: () => onTap(1),
              child: NavButton(
                icon: Icons.route_rounded,
                selected: currentIndex == 1,
              ),
            ),
            GestureDetector(
              onTap: () => onTap(2),
              child: NavButton(
                icon: Icons.notifications_rounded,
                selected: currentIndex == 2,
              ),
            ),
            GestureDetector(
              onTap: () => onTap(3),
              child: NavButton(
                icon: Icons.map_rounded,
                selected: currentIndex == 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
