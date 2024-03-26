import 'package:flutter/material.dart';
import 'package:simup_up/views/components/chip-card.dart';

class ChipsContainer extends StatefulWidget {
  final List<String> chipList;
  final int selectedChip;
  final Function(int) onCardSelected;

  const ChipsContainer({super.key, required this.chipList, required this.onCardSelected, required this.selectedChip});

  @override
  State<ChipsContainer> createState() => _ChipsContainerState();
}

class _ChipsContainerState extends State<ChipsContainer> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.chipList.map((String chipText) {
        return ChipCard(
          label: chipText,
          isSelected: (widget.chipList.indexOf(chipText) == widget.selectedChip),
          onCardTap: () => {
            setState(() {
              widget.onCardSelected(widget.chipList.indexOf(chipText));
            }),
          }
        );
      }).toList(),
    );
  }
}
