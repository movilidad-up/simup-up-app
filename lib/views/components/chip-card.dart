import 'package:flutter/material.dart';

class ChipCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onCardTap;

  const ChipCard({super.key, required this.label, required this.isSelected, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surface,
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
              color: isSelected ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
      ),
    );
  }
}
