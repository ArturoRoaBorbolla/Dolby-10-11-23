import 'dart:io';

import 'package:dolby/layout.dart';
import 'package:dolby/widgets/alert.dart';
import 'package:dolby/service/sqlite_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final LocalStorage storage = LocalStorage('login');
  late SqliteService _sqliteService;
  File photoPathLogin = File('assets/login.jpg');
  File photoPathLogo = File('assets/Dolby_Logo.png');

  _alert(context, title, content) {
    Alert.noticeAlert(context, title, content);
  }

  Future <int> executeInstallation() async {
    //final pipOutputFile = File('${currentDir.path}\\scripts\\common\\pip_output.txt');
    //String pipOutputContent = await pipOutputFile.readAsString();
    //print('Content of  pip_output.txt: $pipOutputContent');

    //Flushbar(
    //  message: pipOutputContent,
    //  duration: Duration(seconds: 5),
    //  backgroundColor: Colors.black,
    //  textColor: Colors.white,
    // )..show(context);
    Directory currentDir = Directory.current;
    final installationScript = '${currentDir.path}\\scripts\\common\\installation.py';
    final pythonCommand = 'python';
    final pythonArguments = [installationScript];
    print("Running python");
    Process.run("python", ["-c","print('Hi World')"]).then((ProcessResult results) {
      exitCode = results.exitCode;
      print("Python execute return ${exitCode}");
      if (exitCode != 0)
      {
        //_alert(context, 'No pyhton Found',
        //    'python cannot be executed.');
        return -1;
      }
    });

    print("Loading libraries");
    Process.run(pythonCommand, pythonArguments).then((ProcessResult results) {
      exitCode = results.exitCode;
      print("Loading libraries return ${exitCode}");
      if (exitCode != 0)
      {
        // _alert(context, 'Libraries Error',
        //     'Some libraries couldnt be loaded.');
        return -2;
      }
    });
    if (exitCode==0)
    {
      //_alert(context, 'Libraries Loaded',
      //    'Libraries have been loaded correctly.');
      return 0;
    }
    throw '';
  }


  @override
  void initState() {
    super.initState();
    _sqliteService = SqliteService();
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(
                photoPathLogin,
              ), //AssetImage('assets/login.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 8,
                ),
                image: DecorationImage(
                  image: FileImage(
                    photoPathLogo,
                  ), //AssetImage('assets/Dolby_Logo.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: TextField(
                      controller: userController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Username",
                          fillColor: Colors.white70),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      obscuringCharacter: "*",
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Password",
                          fillColor: Colors.white70),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var exit = await executeInstallation();
                      if (userController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        _alert(context, 'Failed to login',
                            'Please make sure all fields are filled.');
                        //Directory currentDir = Directory.current;
                        //var data = '${currentDir.path}\\DataBase\\Dolby.db';
                        //_alert(context,data, data);
                      } else
                        print("Value of Exit is ${exit}");
                      if (exit == 0)

                      {

                        await _sqliteService
                            .login(userController.text, passwordController.text)
                            .then((value) {
                          storage.setItem('type_user', value.role);
                          storage.setItem('username', userController.text);
                          storage.setItem('is_loading', false);
                          Get.offAll(() => SiteLayout());
                        }).catchError((e) {
                          _alert(context, 'Failed to login',
                              'Please verify that your credentials are correct.');
                        });

                        // storage.setItem('type_user', 1);
                        // storage.setItem('username', 'admin');
                        // storage.setItem('is_loading', false);
                        // Get.offAll(() => SiteLayout());
                      }
                      else
                      {
                        _alert(context, 'Python Error',
                            'Python or Some Libraries Missing.');
                      }



                    },
                    child: Text('Login to DashBoard'),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
