import 'package:flutter/material.dart';
import 'package:simup_up/views/styles/spaces.dart';

class ActionCard extends StatefulWidget {
  final VoidCallback onSchedulesTap;
  final String subtitle;
  final String title;

  const ActionCard({
    Key? key,
    required this.onSchedulesTap, required this.subtitle, required this.title,
  }) : super(key: key);

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24.0),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.0),
        onTap: widget.onSchedulesTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.subtitle,
                              style: Theme.of(context).textTheme.labelLarge,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                          ],
                        ),
                      ),
                      VerticalSpacing(12.0),
                      Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
