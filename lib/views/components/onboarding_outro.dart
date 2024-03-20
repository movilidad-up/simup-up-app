import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simup_up/views/components/primary_button.dart';
import 'package:simup_up/views/home_view.dart';
import 'package:simup_up/views/styles/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class OnboardingOutro extends StatefulWidget {
  const OnboardingOutro({super.key});

  @override
  State<OnboardingOutro> createState() => _OnboardingOutroState();
}

class _OnboardingOutroState extends State<OnboardingOutro> {
  bool userDataProcessed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        userDataProcessed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: UniqueKey(),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  child: SvgPicture.asset(
                    'assets/images/illustrations/route-lines.svg',
                    fit: BoxFit.fitWidth,
                    width: screenWidth,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.allDone,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0B1215)
                          ),
                        ),
                        VerticalSpacing(8.0),
                        Text(
                          AppLocalizations.of(context)!.enjoyExperience,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF646462)
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: PrimaryButton(buttonText: 'Continuar',
                      onButtonPressed: () {
                        Navigator.of(context).push(CustomPageRoute(const HomeView()));
                      },
                      isButtonEnabled: true,
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}