import 'package:dolby/helpers/local_navigator.dart';
import 'package:dolby/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class LargeScreen extends StatelessWidget {
  LargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: SideMenu()),
      Expanded(
        flex: 5,
        child: localNavigator(),
      )
    ]);
  }
}
