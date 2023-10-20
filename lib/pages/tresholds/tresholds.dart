import 'dart:io';

import 'package:dolby/service/json_service.dart';
import 'package:flutter/material.dart';
import 'package:dolby/pages/tresholds/widgets/tresholds_table.dart';
import 'package:dolby/widgets/card_with_title.dart';
import 'package:dolby/widgets/custom_text.dart';
import 'package:dolby/widgets/section_title.dart';

class TresholdsPage extends StatefulWidget {
  const TresholdsPage({super.key});

  @override
  State<TresholdsPage> createState() => _TresholdsPageState();
}

class _TresholdsPageState extends State<TresholdsPage> {
  JsonService jsonService = JsonService();
  Directory currentDir = Directory.current;
  String header = "";
  List<String> subheaders = [];

  Future readJson(String className) async {
    print(className);
    List jsonResponse = [];
    jsonResponse = await jsonService
        .readJson('${currentDir.path}/assets/json/headers.json');
    for (Map<String, dynamic> section in jsonResponse) {
      section.forEach((key, value) {
        if (key == className) {
          setState(() {
            header = value[0]['header'];
            for (int i = 0; i < value[1]['subheaders'].length; i++) {
              subheaders.add(value[1]['subheaders'][i]['subheader${i + 1}']);
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    readJson((TresholdsPage).toString().replaceAll("Page", "").toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return header.isEmpty && subheaders.isEmpty
        ? Container()
        : SingleChildScrollView(
            child: Center(
                child: Column(children: [
              SectionTitle(
                customText: CustomText(
                  text: header,
                  size: 24,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              CardOptions(textSection: subheaders[0], widget: TableTreshold()),
            ])),
          );
  }
}
