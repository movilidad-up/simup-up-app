import 'package:flutter/material.dart';

class NavButton extends StatefulWidget {
  IconData icon;
  bool selected;

  NavButton({super.key, required this.icon, this.selected = false});

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.selected ? Theme.of(context).colorScheme.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Icon(
          widget.icon,
          color: widget.selected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surface,
          size: 24.0,
        ),
      ),
    );
  }
}
