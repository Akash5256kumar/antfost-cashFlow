import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/navigation/app_routes.dart';

class AppNotificationBell extends StatelessWidget {
  const AppNotificationBell({
    super.key,
    this.showBellDot = true,
    this.onTap,
    this.color = const Color(0xFF4E54F5),
  });

  final bool showBellDot;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Generate hex color string
    final hexColor = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    
    return InkResponse(
      onTap: onTap ?? () => Navigator.of(context).pushNamed(AppRoutes.notifications),
      radius: 20,
      child: SvgPicture.string(
        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M12 3C8.68629 3 6 5.68629 6 9V13.2929C6 13.8233 5.78929 14.3321 5.41421 14.7071L4.29289 15.8284C3.66299 16.4583 4.10914 17.5 5 17.5H19C19.8909 17.5 20.337 16.4583 19.7071 15.8284L18.5858 14.7071C18.2107 14.3321 18 13.8233 18 13.2929V9C18 5.68629 15.3137 3 12 3Z" stroke="$hexColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
        '<path d="M9.5 17.5C9.5 18.8807 10.6193 20 12 20C13.3807 20 14.5 18.8807 14.5 17.5" stroke="$hexColor" stroke-width="1.8" stroke-linecap="round"/>'
        '${showBellDot ? '<circle cx="18" cy="5" r="3.5" fill="$hexColor" stroke="#FFFFFF" stroke-width="1.5"/>' : ''}'
        '</svg>',
        width: 24,
        height: 24,
      ),
    );
  }
}
