import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import 'components/onboarding_frame.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({super.key});

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView> {
  bool showInitialMessage = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        showInitialMessage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: showInitialMessage
                  ? OnboardingIntro()
                  : OnboardingFrame()
          ),
        ),
      ),
    );
  }
}

class OnboardingIntro extends StatelessWidget {
  const OnboardingIntro({super.key});

  @override
  Widget build(BuildContext context) {
    String routeAsset = Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/route-lines.svg' : 'assets/images/illustrations/route-lines-dark.svg';
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
                    routeAsset,
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
                            AppLocalizations.of(context)!.setupExperience,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface
                            ),
                            textScaler: const TextScaler.linear(1.0),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}