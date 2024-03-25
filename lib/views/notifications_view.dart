import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          "This is the notifications view.",
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          )
      ),
    );
  }
}
