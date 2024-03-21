import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simup_up/views/styles/spaces.dart';

class CurrentStationCard extends StatefulWidget {
  const CurrentStationCard({super.key});

  @override
  State<CurrentStationCard> createState() => _CurrentStationCardState();
}

class _CurrentStationCardState extends State<CurrentStationCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEBEAE7),
        borderRadius: BorderRadius.circular(24.0)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/illustrations/station-icon.svg',
              height: 72.0,
            ),
            HorizontalSpacing(24.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Estación aproximada',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                Text(
                    'Fuente Luminosa',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                VerticalSpacing(8.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1215),
                    disabledBackgroundColor: const Color(0xFFEBECEC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  ),
                  onPressed: (){},
                  child: Text(
                    'Ver más',
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToLastDescent: true,
                        applyHeightToFirstAscent: false,
                        leadingDistribution: TextLeadingDistribution.even),
                    style: const TextStyle(
                      height: 1,
                      fontSize: 14.0,
                      color: Color(0xFFFAF9F6),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
