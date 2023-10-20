import 'dart:io';

import 'package:dolby/constants/styles.dart';
import 'package:dolby/widgets/custom_text.dart';
import 'package:dolby/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../../../widgets/alert.dart';

class CardOptions extends StatefulWidget {
  final String textSection;
  final String textCard;
  const CardOptions({super.key, required this.textSection, required this.textCard});

  @override
  State<CardOptions> createState() => _CardOptionsState();
}

class _CardOptionsState extends State<CardOptions> {
  
  Directory current_dir = Directory.current;

  late bool isLoading;
  final LocalStorage storage = LocalStorage('login');
  setLoading(bool state) => setState(() => isLoading = state);

  _alert(BuildContext context, String title, String content) {
    Alert.noticeAlert(context, title, content);
  }

  @override
  void initState() {
    super.initState();
    if (storage.getItem('is_loading') == null) {
      setLoading(false);
    } else {
      setLoading(storage.getItem('is_loading'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      elevation: 10,
      child: TextButton(
        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.lightBlue[50]),),
        onPressed: 
          isLoading ? null :
          () async {
            if (widget.textCard == "Update"){
              setLoading(true);
              storage.setItem('is_loading', true);
              String pyscript = "${current_dir.path}\\DataBase\\csv_to_sqlite.py";
              print(pyscript);
              await Process.run('python', [pyscript]).then((ProcessResult rs){
                print(rs.stdout + rs.toString() + rs.stderr);
              });
              setLoading(false);
              storage.deleteItem('is_loading');
              _alert(context, 'Updated',
                  'DataBase Updated.');              
            }
            if (widget.textCard == "Access to my database"){
              //Get.to(() => SeeTablesPage());
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
          },
        child: Column(
          children: <Widget>[
            SectionTitle(
              color: navyBlue,
              height: 40,
              customText: CustomText(
                text: widget.textSection,
                size: 26,
                weight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.textCard,
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        )
      ),
    );
  }
}
