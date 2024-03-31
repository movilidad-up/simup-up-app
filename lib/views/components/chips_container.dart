import 'package:flutter/material.dart';
import 'package:simup_up/views/components/chip-card.dart';

class ChipsContainer extends StatefulWidget {
  final List<String> chipList;
  final bool hasRestrictions;
  final int chipsEnabled;
  final int selectedChip;
  final Function(int) onCardSelected;

  const ChipsContainer({super.key, required this.chipList, required this.onCardSelected, required this.selectedChip, this.chipsEnabled = 0, this.hasRestrictions = false});

  @override
  State<ChipsContainer> createState() => _ChipsContainerState();
}

class _ChipsContainerState extends State<ChipsContainer> {
  void _handleChipTap(String value) {
      setState(() {
        widget.onCardSelected(widget.chipList.indexOf(value));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.chipList.map((String chipText) {
        return ChipCard(
          label: chipText,
          isSelected: (widget.chipList.indexOf(chipText) == widget.selectedChip),
          isEnabled: widget.hasRestrictions ? (widget.chipList.indexOf(chipText) < widget.chipsEnabled) : true,
          onCardTap: () => {
            _handleChipTap(chipText),
          }
        );
      }).toList(),
    );
  }
}
