import 'dart:convert';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:dolby/pages/dashboard/models/PriorityTest.dart';
import 'package:dolby/pages/json_table/json_table.dart';
import 'package:dolby/pages/view/view.dart';
import 'package:dolby/service/json_service.dart';
import 'package:dolby/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HighPriorityTests extends StatefulWidget {
  const HighPriorityTests({super.key});

  @override
  State<HighPriorityTests> createState() => HighPriorityTestsState();
}

class HighPriorityTestsState extends State<HighPriorityTests> {
  Future<List> readJson() async {
    List jsonResponse = [];
    List jsonResponseReversed = [];
    JsonService jsonService = JsonService();
    Directory currentDir = Directory.current;

    jsonResponse = await jsonService
        .readJson('${currentDir.path}/assets/json/high_priority_tests.json');
    jsonResponseReversed = jsonResponse.reversed.toList();
    return jsonResponseReversed;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return JsonTable(jsonList: readJson());
  }
}
