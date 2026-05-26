import 'package:flutter/material.dart';

/// Sharp, motion-light transition for the high-density Utility brand.
class SharpPageTransitionsBuilder extends PageTransitionsBuilder {
  const SharpPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
