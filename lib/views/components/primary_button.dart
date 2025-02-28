import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool hasPadding;
  final bool isButtonEnabled;
  final bool primaryStyle;

  const PrimaryButton({
    Key? key,
    required this.buttonText,
    required this.onButtonPressed,
    required this.isButtonEnabled,
    this.primaryStyle = true,
    this.hasPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Color _getButtonColor() {
      if (isButtonEnabled) {
        if (primaryStyle) {
          return Theme.of(context).colorScheme.surface;
        } else {
          return Theme.of(context).colorScheme.onSurface;
        }
      } else {
        return Theme.of(context).colorScheme.onTertiaryContainer;
      }
    }

    return Padding(
      padding: hasPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryStyle ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainer,
          disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          minimumSize: Size(screenWidth, 0),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: isButtonEnabled ? onButtonPressed : null,
        child: Text(
          buttonText,
          style: TextStyle(
            color: _getButtonColor(),
          ),
          textScaler: const TextScaler.linear(1.0),
        ),
      ),
    );
  }
}
