import 'package:flutter/material.dart';

class ProgressNav extends StatelessWidget {
  final double progressValue;
  final VoidCallback onBackPressed;

  const ProgressNav(
      {Key? key, required this.progressValue, required this.onBackPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: onBackPressed,
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF0B1215),
                size: 24.0,
              ),
            ),
          ),
          Flexible(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progressValue),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  semanticsLabel: 'Onboarding progress indicator',
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF0B1215)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text('${(progressValue * 100).round()}%'),
          ),
        ],
      ),
    );
  }
}
