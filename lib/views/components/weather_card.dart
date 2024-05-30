import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/schedules_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class WeatherCard extends StatefulWidget {
  final VoidCallback onCloseTap;

  const WeatherCard({
    Key? key,
    required this.onCloseTap,
  }) : super(key: key);

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24.0),
      color: const Color(0xFFDEE1EC),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.wb_cloudy_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.systemDelays,
                          style: const TextStyle(
                              color: Color(0xFF6B7DC1),
                              fontSize: 16.0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.rainyWeather,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacing(12.0),
                    Material(
                      color: const Color(0xFFC9CFE4),
                      borderRadius: BorderRadius.circular(8.0),
                      child: InkWell(
                        onTap: widget.onCloseTap,
                        splashColor: const Color(0xFFB5BDDD),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
