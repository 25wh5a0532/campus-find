/// App-wide layout and content constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'CampusFind';
  static const String appTagline =
      'Lost something? Found something? CampusFind brings it back.';
  static const String appVersion = '1.0.0';

  // Layout breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1280;

  // Max content width for desktop
  static const double maxContentWidth = 1200;

  // Spacing
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  // NavBar height
  static const double navBarHeight = 64;

  // Card
  static const double cardElevation = 0;
  static const double cardBorderWidth = 1;

  // Padding
  static const double pagePaddingHorizontal = 24;
  static const double pagePaddingVertical = 32;
}
