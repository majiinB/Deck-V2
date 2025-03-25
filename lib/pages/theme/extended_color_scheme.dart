import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ExtendedColorScheme extends ColorScheme {
  final Color tertiary;
  final Color onTertiary;
  final Color outline;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;
  final Color surfaceTint;

  const ExtendedColorScheme({
    required Brightness brightness,
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color onSecondary,
    required Color surface,
    required Color background,
    required Color error,
    required Color onSurface,
    required Color onBackground,
    required Color onError,
    required this.tertiary,
    required this.onTertiary,
    required this.outline,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.surfaceTint,
  }) : super(
          brightness: brightness,
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          surface: surface,
          background: background,
          error: error,
          onSurface: onSurface,
          onBackground: onBackground,
          onError: onError,
        );
}
