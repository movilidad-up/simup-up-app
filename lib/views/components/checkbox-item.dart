import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simup_up/views/utils/shared_prefs.dart';

class CheckboxItem extends StatefulWidget {
  final String label;
  final String description;
  final String preferenceKey;

  const CheckboxItem({
    Key? key,
    required this.label,
    required this.description,
    required this.preferenceKey,
  }) : super(key: key);

  @override
  State<CheckboxItem> createState() => _CheckboxItemState();
}

class _CheckboxItemState extends State<CheckboxItem> {
  final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());
  bool isChecked = false;
  late StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    _loadState();

    // Subscribe to the stream and store the subscription
    _subscription = rxPrefs
        .getBoolStream(widget.preferenceKey)
    !.where((value) => value != null)
        .cast<bool>()
        .listen((value) {
      setState(() {
        isChecked = value;
      });
    });
  }

  Future<void> _loadState() async {
    bool? prefState = await rxPrefs.getBool(widget.preferenceKey) ?? false;
    setState(() {
      isChecked = prefState;
    });
  }

  Future<void> _saveState(bool value) async {
    rxPrefs.setBool(widget.preferenceKey, value);
  }

  void _updatePreferenceState(String preferenceKey, bool pushState) async {
    await SharedPrefs().prefs.setBool(preferenceKey, pushState);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
        stream: rxPrefs.getBoolStream(widget.preferenceKey)?.where((value) => value != null).cast<bool>() ?? Stream<bool>.empty(),
        initialData: isChecked,
        builder: (context, snapshot) {
          isChecked = snapshot.data ?? false;
          return SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12.0, right: 24.0, bottom: 12.0, left: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.64,
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
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      activeColor: Theme.of(context).colorScheme.surface,
                      activeTrackColor: Theme.of(context).colorScheme.secondary,
                      inactiveTrackColor: Theme.of(context).colorScheme.surface,
                      value: isChecked,
                      onChanged: (value) {
                        try {
                          _updatePreferenceState(widget.preferenceKey, value);
                        } catch (err) {
                          log(err.toString());
                        }

                        setState(() {
                          isChecked = value;
                        });
                        _saveState(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
