import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/views/components/onboarding_card.dart';
import 'package:simup_up/views/get_started_view.dart';
import 'package:simup_up/views/utils/custom-page-router.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int currentView = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<String> images = [
      Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/get-started-routes.svg' : 'assets/images/illustrations/get-started-routes-dark.svg',
      Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/get-started-displacement.svg' : 'assets/images/illustrations/get-started-displacement-dark.svg',
      Theme.of(context).colorScheme.brightness == Brightness.light ? 'assets/images/illustrations/get-started-notifications.svg' : 'assets/images/illustrations/get-started-notifications-dark.svg',
    ];

    void _updateNextView() {
      setState(() {
        if (currentView < 2) {
          currentView++;
        } else {
          Navigator.of(context).push(CustomPageRoute(const GetStartedView()));
        }
      });
    }

    void _updatePreviousView() {
      setState(() {
        if (currentView > 0) {
          currentView--;
        }
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: SizedBox(
            key: UniqueKey(),
            height: screenHeight,
            width: screenWidth,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SvgPicture.asset(
                    images.elementAt(currentView),
                    fit: BoxFit.fitWidth,
                    width: screenWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedOpacity(
                    opacity: (currentView > 0) ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: IconButton(
                          onPressed: (currentView > 0) ? () {
                            _updatePreviousView();
                          } : null,
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 24.0,
                          )),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: OnboardingCard(
                    currentIndex: currentView,
                    items: [
                      {'title': AppLocalizations.of(context)!.onboardTitle1, 'subtitle': AppLocalizations.of(context)!.onboardSubtitle1},
                      {'title': AppLocalizations.of(context)!.onboardTitle2, 'subtitle': AppLocalizations.of(context)!.onboardSubtitle2},
                      {'title': AppLocalizations.of(context)!.onboardTitle3, 'subtitle': AppLocalizations.of(context)!.onboardSubtitle3},
                    ],
                    onNextPressed: _updateNextView,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
