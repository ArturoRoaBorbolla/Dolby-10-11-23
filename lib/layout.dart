import 'package:dolby/helpers/responsiveness.dart';
import 'package:dolby/widgets/large_screen.dart';
import 'package:dolby/widgets/side_menu.dart';
import 'package:dolby/widgets/small_screen.dart';
import 'package:dolby/widgets/top_navbar.dart';
import 'package:flutter/material.dart';

class SiteLayout extends StatelessWidget {
  SiteLayout({super.key});
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: topNavigationBar(context, scaffoldKey),
        drawer: Drawer(
          child: SideMenu(),
        ),
        body: ResponsiveWidget(
          largeScreen: LargeScreen(),
          smallScreen: SmallScreen(),
        ));
  }
}
