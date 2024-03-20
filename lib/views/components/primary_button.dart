import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool hasPadding;
  final bool isButtonEnabled;

  const PrimaryButton({
    Key? key,
    required this.buttonText,
    required this.onButtonPressed,
    required this.isButtonEnabled,
    this.hasPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: hasPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF102F9F),
          disabledBackgroundColor: const Color(0xFFEBECEC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          minimumSize: Size(screenWidth, 0),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: isButtonEnabled ? onButtonPressed : null,
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Color(0xFFFAF9F6),
          ),
        ),
      ),
    );
  }
}
