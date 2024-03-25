import 'package:flutter/material.dart';
import 'package:simup_up/views/styles/spaces.dart';

class InfoTip extends StatelessWidget {
  final String tipTitle;
  final String tipDescription;
  final IconData tipIcon;

  const InfoTip({super.key, required this.tipTitle, required this.tipDescription, required this.tipIcon});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              tipIcon,
              color: Theme.of(context).colorScheme.onBackground,
              size: 24.0,
            ),
          ),
        ),
        HorizontalSpacing(16.0),
        SizedBox(
          width: screenWidth * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tipTitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onBackground
                ),
              ),
              Text(
                tipDescription,
                maxLines: 3,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
