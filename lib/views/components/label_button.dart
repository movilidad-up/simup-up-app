import 'package:flutter/material.dart';
import 'package:simup_up/views/styles/spaces.dart';

class LabelButton extends StatelessWidget {
  final IconData buttonIcon;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool hasPadding;
  final bool isButtonEnabled;

  const LabelButton({
    Key? key,
    required this.buttonText,
    required this.onButtonPressed,
    required this.isButtonEnabled,
    this.hasPadding = true, required this.buttonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: hasPadding ? const EdgeInsets.all(4.0) : EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          animationDuration: const Duration(milliseconds: 200),
          splashFactory: InkSparkle.splashFactory,
          backgroundColor: Theme.of(context).colorScheme.primary,
          disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
              vertical: 8.0
          ),
        ),
        onPressed: isButtonEnabled ? onButtonPressed : null,
        child: Row(
          children: [
            Icon(
                buttonIcon,
                color: isButtonEnabled ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onTertiaryContainer,
            ),
            HorizontalSpacing(4.0),
            Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: isButtonEnabled ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              textScaler: const TextScaler.linear(1.0),
            ),
          ],
        ),
      ),
    );
  }
}
