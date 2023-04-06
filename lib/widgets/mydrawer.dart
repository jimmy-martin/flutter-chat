
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/globals.dart';
import 'package:flutter_chat/repositories/customer_repository.dart';
import 'package:flutter_chat/services/firestore_helper.dart';



class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDrawerState();
  }
}

class MyDrawerState extends State<MyDrawer> {
  //variable
  String? nameImage;
  String? urlImage;
  Uint8List? dataImage;

  //méthode
  popUpChoix() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Votre image"),
            content: Image.memory(dataImage!),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler")),
              TextButton(
                  onPressed: () {
                    FirestoreHelper()
                        .uploadImage(
                            folder: "avatars",
                            personnalFolder: myUser.id,
                            imageName: nameImage!,
                            bytesImage: dataImage!)
                        .then((urlBaseDeDonne) {
                      urlImage = urlBaseDeDonne;
                      //récupérer l'url
                      Map<String, dynamic> data = {"avatar": urlImage};
                      setState(() {
                        myUser.avatar = urlImage;
                      });
                      //mettre à jour les infos utilisateurs
                      CustomerRepository().updateCustomer(myUser.id, data);
                      //fermer le nouveau pop
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Upload"))
            ],
          );
        });
  }

  popImage() async {
    FilePickerResult? resultat = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);
    if (resultat != null) {
      nameImage = resultat.files.first.name;
      dataImage = resultat.files.first.bytes;
      popUpChoix();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        //avatar
        //cliqubale pour changer la photo de l'avatar
        InkWell(
          onTap: () {
            //on va faire appel au menu des photos
            popImage();
          },
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(myUser.avatar!),
          ),
        ),

        Text(myUser.nickname ?? ""),

        //prenom et nom
        Text(myUser.fullName),

        //pseudo
        //poura enregitrer un nouveau pseudo

        //mail
        Text(myUser.email)
      ]),
    );
  }
}
