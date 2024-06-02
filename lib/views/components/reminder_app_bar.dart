import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReminderAppBar extends StatelessWidget {
  final bool isEditing;
  final Function() onDelete;
  final Function() onBack;

  const ReminderAppBar({
    required this.isEditing,
    required this.onDelete,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        isEditing
            ? AppLocalizations.of(context)!.editReminder
            : AppLocalizations.of(context)!.addReminder,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      scrolledUnderElevation: 0.2,
      actions: [
        isEditing
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            enableFeedback: false,
            icon: Icon(
              Icons.delete_forever_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: onDelete,
          ),
        )
            : SizedBox(),
      ],
      leading: IconButton(
        enableFeedback: false,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: onBack,
      ),
    );
  }
}
