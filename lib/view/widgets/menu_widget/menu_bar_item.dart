import 'package:flutter/material.dart';

List<MenuBarItem> items = [
  MenuBarItem(
    icon: Icon(Icons.home),
    title: Text("Home"),
    selectedColor: Colors.purple,
  ),
  MenuBarItem(
    icon: Icon(Icons.qr_code_scanner),
    title: Text("Scan"),
    selectedColor: Colors.pink,
  ),
  MenuBarItem(
    icon: Icon(Icons.switch_access_shortcut),
    title: Text("Search"),
    selectedColor: Colors.orange,
  ),
  MenuBarItem(
    icon: Icon(Icons.person),
    title: Text("Profile"),
    selectedColor: Colors.teal,
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
