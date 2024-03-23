import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/styles/spaces.dart';

class StationCard extends StatelessWidget {
  final String name;
  final String arrivalInfo;
  final bool isCurrentStation;
  final VoidCallback onTap;
  const StationCard({super.key, required this.name, required this.arrivalInfo, required this.onTap, required this.isCurrentStation});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: screenWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isCurrentStation ? Color(0xFFECEEF6) : Color(0xFFFAF9F6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                    isCurrentStation ? 'assets/images/illustrations/station-line-enabled.svg' : 'assets/images/illustrations/station-line-disabled.svg',
                    fit: BoxFit.fill,
                ),
                HorizontalSpacing(0.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    VerticalSpacing(4.0),
                    Text(
                      isCurrentStation
                          ? AppLocalizations.of(context)!.currentStation + arrivalInfo
                          : AppLocalizations.of(context)!.arrivalTime + arrivalInfo,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.black54,
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    VerticalSpacing(4.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Más información",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF4B71F8),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Color(0xFF4B71F8),
                          size: 20.0,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
