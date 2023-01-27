import 'package:flutter/material.dart';

List<MenuBarItem> items = [
  MenuBarItem(
    icon: const Icon(Icons.home),
    title: const Text(
      "Home",
      textAlign: TextAlign.center,
    ),
    selectedColor: Colors.purple,
  ),
  MenuBarItem(
    icon: const Icon(Icons.qr_code_scanner),
    title: const Text(
      "Scan",
      textAlign: TextAlign.center,
    ),
    selectedColor: Colors.pink,
  ),
  MenuBarItem(
    icon: const Icon(Icons.switch_access_shortcut),
    title: const Text(
      "Dressing Room",
      textAlign: TextAlign.center,
    ),
    selectedColor: Colors.orange,
  ),
  MenuBarItem(
    icon: const Icon(Icons.add_card),
    title: const Text(
      "Orders",
      textAlign: TextAlign.center,
    ),
    selectedColor: Colors.teal,
  ),
];

List<MenuBarItem> clerkItems = [
  MenuBarItem(
    icon: const Icon(Icons.home),
    title: const Text(
      "Home",
      textAlign: TextAlign.center,
    ),
    selectedColor: Colors.purple,
  ),
  MenuBarItem(
    icon: const Icon(Icons.qr_code_scanner),
    title: const Text(
      "Scan",
      textAlign: TextAlign.center,
    ),
    selectedColor: Colors.pink,
  ),
  MenuBarItem(
    icon: const Icon(Icons.notifications_none),
    title: const Text(
      "Notifications",
      textAlign: TextAlign.center,
    ),
    selectedColor: Colors.orange,
  ),
];

class MenuBarItem {
  final Widget icon;
  final Widget? activeIcon;
  final Widget title;
  final Color? selectedColor;
  final Color? unselectedColor;

  MenuBarItem({
    required this.icon,
    required this.title,
    this.selectedColor,
    this.unselectedColor,
    this.activeIcon,
  });
}
