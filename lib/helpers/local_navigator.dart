import 'package:dolby/constants/controllers.dart';
import 'package:dolby/routing/router.dart';
import 'package:dolby/routing/routes.dart';
import 'package:flutter/material.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigationKey,
      initialRoute: DashViewPageRoute,
      onGenerateRoute: generateRoute,
    );
