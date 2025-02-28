import 'package:flutter/material.dart';

class OptionItem extends StatefulWidget {
  final String label;
  final String description;
  final bool isClickable;
  final VoidCallback onTap;

  const OptionItem({Key? key, required this.label, required this.description, required this.isClickable, required this.onTap})
      : super(key: key);

  @override
  State<OptionItem> createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, right: 24.0, bottom: 12.0, left: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth * 0.72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                ],
              ),
            ),
            if (widget.isClickable) ... [
              IconButton(
                onPressed: widget.onTap,
                icon: Icon(
                  Icons.keyboard_arrow_right_rounded, color: Theme.of(context).colorScheme.tertiary,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
