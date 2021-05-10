import 'package:flutter/cupertino.dart';

class TabbarItem {
  final String label;
  final IconData icon;
  final GlobalKey key;
  TabbarItem({required this.label, required this.icon, required this.key});
}