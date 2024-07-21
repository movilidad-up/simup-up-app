import 'package:flutter/material.dart';

class ChipCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onCardTap;

  const ChipCard({super.key, required this.label, required this.isSelected, required this.onCardTap, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    Color _getTextColor() {
      if (isEnabled) {
        return isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface;
      } else {
        return Theme.of(context).colorScheme.onTertiaryContainer;
      }
    }

    return GestureDetector(
      onTap: isEnabled ? onCardTap : null,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8.0)
          ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              color: _getTextColor(),
            ),
            textScaler: const TextScaler.linear(1.0),
          ),
        ),
      ),
    );
  }
}
