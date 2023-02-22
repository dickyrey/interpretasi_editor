import 'package:flutter/material.dart';
import 'package:interpretasi_editor/src/common/const.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobileBody,
    required this.desktopBody,
    required this.webBody,
    super.key,
  });

  final Widget mobileBody;
  final Widget desktopBody;
  final Widget webBody;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 650;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Const.webWidth) {
          return webBody;
        } else if (constraints.maxWidth >= Const.desktopWidth) {
          return desktopBody;
        } else {
          return mobileBody;
        }
      },
    );
  }
}
