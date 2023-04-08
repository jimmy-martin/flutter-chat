import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/firebase_options.dart';
import 'package:flutter_chat/globals.dart';
import 'package:flutter_chat/services/firestore_helper.dart';
import 'package:flutter_chat/services/permission_helper.dart';
import 'package:flutter_chat/widgets/dashboard.dart';
import 'package:flutter_chat/widgets/loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PermissionHelper().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: defaultColor,
      ),
      home: const LoadingPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  List<bool> selection = [true, false];

  String selectedLanguage = "fr";

  //Méthode
  popUp() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            return CupertinoAlertDialog(
              title: const Text("Erreur"),
              content: const Text(
                  "Votre email et/ou votre mot de passe sont incorrectes"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            );
          } else {
            return AlertDialog(
              title: const Text("Erreur"),
              content: const Text(
                  "Votre email et/ou votre mot de passe sont incorrectes"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Flutter Chat"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: bodyPage(),
        ));
  }

  Widget bodyPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ToggleButtons(
            selectedColor: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            onPressed: (int choice) {
              if (choice == 0) {
                setState(() {
                  selection[0] = true;
                  selection[1] = false;
                });
              } else {
                setState(() {
                  selection[0] = false;
                  selection[1] = true;
                });
              }
            },
            isSelected: selection,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Connexion", style: TextStyle(color: defaultColor)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child:
                    Text("Inscription", style: TextStyle(color: defaultColor)),
              ),
            ],
          ),

          //image
          const SizedBox(height: 5),
          Image.network(defaultImage, height: 200, width: 200),
          const SizedBox(height: 5),

          if (selection[0] == false)
            Column(
              children: [
                _buildLanguageDropdown(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: firstname,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Prénom",
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: lastname,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Nom",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          const SizedBox(height: 10),
          TextField(
            controller: mail,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Email"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Mot de passe"),
          ),
          const SizedBox(height: 10),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: defaultColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (selection[0] == false) {
                //si on en mode inscription
                FirestoreHelper()
                    .register(mail.text, password.text, lastname.text,
                        firstname.text, selectedLanguage)
                    .then((value) {
                  //si la méthode fonctionne bien
                  setState(() {
                    myUser = value;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DashBoard(mail: mail.text, password: password.text);
                  }));
                }).catchError((onError) {
                  //si on constate une erreur
                  popUp();
                });
              } else {
                //si en mode connexion
                FirestoreHelper()
                    .connect(mail.text, password.text)
                    .then((value) {
                  setState(() {
                    myUser = value;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DashBoard(mail: mail.text, password: password.text);
                  }));
                }).catchError((onError) {
                  popUp();
                });
              }
            },
            child: const Text('Valider'),
          )
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    final Map<String, String> languageMapping = {
      "fr": "Français",
      "en": "Anglais",
      "es": "Espagnol",
      "de": "Allemand"
    };

    return DropdownButton<String>(
      value: selectedLanguage,
      onChanged: (String? newValue) {
        setState(() {
          selectedLanguage = newValue!;
        });
      },
      items: languageMapping.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(languageMapping[value]!),
        );
      }).toList(),
      dropdownColor: Colors.grey[200],
      style: const TextStyle(color: Colors.black, fontSize: 18),
      icon: const Icon(Icons.language),
      iconSize: 30,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.grey[400],
      ),
    );
  }
}

class Styles {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );
}
