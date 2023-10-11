import 'package:dolby/helpers/responsiveness.dart';
import 'package:dolby/widgets/horizontal_menu_item.dart';
import 'package:dolby/widgets/vertical_menu_item.dart';
import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String itemName;
  final void Function() onTap;

  const SideMenuItem({super.key, required this.itemName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomSize(context)) {
      return VerticalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    }

    return HorizontalMenuItem(
      itemName: itemName,
      onTap: onTap,
    );
  }
}
