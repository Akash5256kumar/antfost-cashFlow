import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/theme/app_colors.dart';

/// Clean, pixel-perfect SVG vector icons matching the Figma design specification.

String _hex(Color c) => '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

class AppSvgUserIcon extends StatelessWidget {
  const AppSvgUserIcon({
    super.key,
    this.color = AppColors.iconMuted,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    return SvgPicture.string(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<circle cx="12" cy="8" r="3.8" stroke="$c" stroke-width="1.6"/>'
      '<path d="M5.5 18.5C5.5 15.5 8.4 13.5 12 13.5C15.6 13.5 18.5 15.5 18.5 18.5H5.5Z" stroke="$c" stroke-width="1.6" stroke-linejoin="round"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }
}

class AppSvgPhoneIcon extends StatelessWidget {
  const AppSvgPhoneIcon({
    super.key,
    this.color = AppColors.iconMuted,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    return SvgPicture.string(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<rect x="7" y="3.5" width="10" height="17" rx="2.5" stroke="$c" stroke-width="1.5"/>'
      '<line x1="10.5" y1="17.5" x2="13.5" y2="17.5" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }
}

class AppSvgLockIcon extends StatelessWidget {
  const AppSvgLockIcon({
    super.key,
    this.color = AppColors.iconMuted,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    return SvgPicture.string(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<rect x="5.5" y="10" width="13" height="10" rx="2.5" stroke="$c" stroke-width="1.5"/>'
      '<path d="M8.5 10V7C8.5 5.067 10.067 3.5 12 3.5C13.933 3.5 15.5 5.067 15.5 7V10" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '<circle cx="12" cy="15" r="1.2" fill="$c"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }
}

class AppSvgBusinessIcon extends StatelessWidget {
  const AppSvgBusinessIcon({
    super.key,
    this.color = AppColors.iconMuted,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    return SvgPicture.string(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<path d="M5 20V6C5 4.89543 5.89543 4 7 4H12C13.1046 4 14 4.89543 14 6V20M5 20H14M5 20H3M14 20H19C19.5523 20 20 19.5523 20 19V10.5C20 9.94772 19.5523 9.5 19 9.5H14" stroke="$c" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>'
      '<path d="M8 14H11V20H8V14Z" stroke="$c" stroke-width="1.3" stroke-linejoin="round"/>'
      '<path d="M16 13.5H17.5" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }
}

class AppSvgEyeIcon extends StatelessWidget {
  const AppSvgEyeIcon({
    super.key,
    this.color = AppColors.textSecondary,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    return SvgPicture.string(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<path d="M1 12C1 12 5 4 12 4C19 4 23 12 23 12C23 12 19 20 12 20C5 20 1 12 1 12Z" stroke="$c" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>'
      '<circle cx="12" cy="12" r="3" stroke="$c" stroke-width="1.5"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }
}

class AppSvgEyeOffIcon extends StatelessWidget {
  const AppSvgEyeOffIcon({
    super.key,
    this.color = AppColors.textSecondary,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    return SvgPicture.string(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<path d="M17.94 17.94A10.07 10.07 0 0112 20C5 20 1 12 1 12C2.24 9.68 4.2 7.6 6.57 6.36M9.9 4.24A9.12 9.12 0 0112 4C19 4 23 12 23 12C22.12 13.63 20.88 15.11 19.37 16.27" stroke="$c" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>'
      '<path d="M1 1L23 23" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '<path d="M9.88 9.88A3 3 0 1014.12 14.12" stroke="$c" stroke-width="1.5"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }
}

class AppSvgDocumentIcon extends StatelessWidget {
  const AppSvgDocumentIcon({
    super.key,
    this.color = AppColors.primary,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    return SvgPicture.string(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<path d="M14 2H6C4.89543 2 4 2.89543 4 4V20C4 21.1046 4.89543 22 6 22H18C19.1046 22 20 21.1046 20 20V8L14 2Z" stroke="$c" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>'
      '<path d="M14 2V8H20" stroke="$c" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>'
      '<line x1="8" y1="13" x2="16" y2="13" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '<line x1="8" y1="17" x2="13" y2="17" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }
}

class AppSvgLicenseCardIcon extends StatelessWidget {
  const AppSvgLicenseCardIcon({
    super.key,
    this.color = AppColors.primary,
    this.size = 20,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    return SvgPicture.string(
      '<svg width="$size" height="$size" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<rect x="3" y="4" width="18" height="16" rx="2.5" stroke="$c" stroke-width="1.5"/>'
      '<rect x="6" y="8" width="5" height="5" rx="1" stroke="$c" stroke-width="1.3"/>'
      '<line x1="13" y1="9" x2="18" y2="9" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '<line x1="13" y1="12" x2="17" y2="12" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '<line x1="6" y1="16" x2="18" y2="16" stroke="$c" stroke-width="1.5" stroke-linecap="round"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }
}
