import 'dart:io';

import 'package:dolby/constants/styles.dart';
import 'package:dolby/pages/see_tables/widgets/tables.dart';
import 'package:dolby/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SeeTablesPage extends StatelessWidget {
  const SeeTablesPage({super.key});


  void runSQLiteDatabaseBrowser( ) async {
    print("run sql");
    Directory currentDir = Directory.current;
    String path = '${currentDir.path}\\DataBase\\SQLiteDatabaseBrowserPortable\\SQLiteDatabaseBrowserPortable.exe';
    List<String> arguments = ['${currentDir.path}\\DataBase\\Dolby.db'];
    ProcessResult result = await Process.run(path, arguments);

    if (result.exitCode == 0) {
      print("success");
    } else {
      print("error");
    }
  }


  @override
  void initState() {
    runSQLiteDatabaseBrowser();
  }

  @override
  Widget build(BuildContext context) {

    runSQLiteDatabaseBrowser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brown,
        title: CustomText(
          text: 'Database Tables',
          size: 24,
          weight: FontWeight.bold,
          color: Colors.white,
      )),
      body: Tables()
    );
  }
}