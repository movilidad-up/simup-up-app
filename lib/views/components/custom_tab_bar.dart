import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabTapped;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        tabs.length,
            (index) => Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () => onTabTapped(index),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: selectedIndex == index ? Theme.of(context).colorScheme.onBackground : Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: selectedIndex == index ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}