import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:simup_up/views/styles/spaces.dart';

class CustomToast {
  static void buildToast(BuildContext context, Color primaryColor, String title, String body, IconData icon) {
    showToastWidget(
        GestureDetector(
          onTap: () => ToastManager().dismissAll(showAnim: true),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 64.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(width: 1.0, color: primaryColor),

            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                    icon,
                    size: 32.0,
                    color: primaryColor
                ),
                HorizontalSpacing(16.0),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.visible,
                        maxLines: 4,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: primaryColor,
                        ),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      VerticalSpacing(4.0),
                      Text(
                        body,
                        overflow: TextOverflow.visible,
                        maxLines: 4,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                          color: primaryColor.withOpacity(0.64),
                        ),
                        textScaler: const TextScaler.linear(1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        context: context,
        dismissOtherToast: true,
        isIgnoring: false,
        animation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.bottom,
        animDuration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut
    );
  }
}
