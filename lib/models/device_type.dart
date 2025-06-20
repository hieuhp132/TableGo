import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

enum DeviceType { mobile, tablet, desktop }

DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  bool isMobileWidth() => width <= 600;
  bool isTabletWidth() => width > 600 && width <= 900;
  bool isDesktopWidth() => width > 900;

  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
    return isTabletWidth() || isDesktopWidth()
        ? DeviceType.tablet
        : DeviceType.mobile;
  } else if (UniversalPlatform.isWeb) {
    if (isDesktopWidth()) return DeviceType.desktop;
    if (isTabletWidth()) return DeviceType.tablet;
    return DeviceType.mobile;
  } else {
    // Windows, macOS, Linux
    return DeviceType.desktop;
  }
}
