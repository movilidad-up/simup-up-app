import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simup_up/views/components/current_station_card.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String? userName;

  @override
  void initState() {
    userName = '';
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 32.0, bottom: 32.0, left: 24.0, right: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                                '${AppLocalizations.of(context)!.hello}, ${userName ?? AppLocalizations.of(context)!.guestTitle}!',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                                textAlign: TextAlign.start),
                          ),
                          Text(AppLocalizations.of(context)!.awesomeDay,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        //Navigator.of(context)
                        //    .push(CustomPageRoute(const SettingsView()));
                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
                VerticalSpacing(24.0),
                Expanded(
                  child: Column(
                    children: [
                      CurrentStationCard(),
                    ],
                  ),
                ),
                // Align(
                //     alignment: Alignment.bottomCenter,
                //     child: BottomNavbar()
                // )
              ],
            ),
          ),
        ));
  }
}