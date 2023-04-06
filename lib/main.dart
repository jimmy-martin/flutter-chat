import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/firebase_options.dart';
import 'package:flutter_chat/services/permission_helper.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Home Page'),
      debugShowCheckedModeBanner: false,
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
  TextEditingController prenom = TextEditingController();
  TextEditingController nom = TextEditingController();
  List<bool> selection = [true, false];



  //Méthode
  popUp(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if (defaultTargetPlatform == TargetPlatform.iOS){
            return CupertinoAlertDialog(
              title: const Text("Erreur"),
              content: const Text("Votre email et/ou votre mot de passe sont incorrectes"),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("ok")
                )
              ],

            );
          }
          else
          {
            return AlertDialog(
              title: const Text("Erreur"),
              content: const Text("Votre email et/ou votre mot de passe sont incorrectes"),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("ok")
                )
              ],
            );
          }
        }
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Chat"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: bodyPage(),
        ));
  }

  Widget bodyPage() {
    return Column(
      children: [

        ToggleButtons(

          selectedColor: Colors.blue,

          borderRadius: BorderRadius.circular(10),



          onPressed: (int choix) {
            if (choix == 0) {
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
          children: const [ Text("Connexion"),  Text("Inscription")       ],


        ),

        //image
        const SizedBox(height:5),
        Image.network("https://img.icons8.com/clouds/512/user.png"),
        const SizedBox(height:5),





        const SizedBox(height: 20),
        const SizedBox(height: 20),
        if (selection[0] == false)


          Row(   children:[

            Container( width: MediaQuery.of(context).size.width*0.5,
              child: TextField(

                controller: prenom,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Prénom"),
              ),
            ),


            const SizedBox(width: 15),
            if (selection[0] == false)

              Container( width: MediaQuery.of(context).size.width*0.4,
                child: TextField(

                  controller: nom,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Nom"),
                ),
              ),
          ]
          ),





        const SizedBox(height: 10),
        TextField(
          controller: mail,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              hintText: "Email"),

        ),
        const SizedBox(height: 10),
        TextField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              hintText: "Mot de passe"),
        ),
        const SizedBox(height: 10),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          onPressed: (){

            if(selection[0]== false){
              //si on en mode inscription
              FirestoreHelper().Inscription(mail.text, password.text, nom.text, prenom.text).then((value) {
                //si la méthode fonctionne bien
                setState(() {
                  monUtilisateur = value;
                });
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return DashBoardView(mail: mail.text, password: password.text);
                    }
                ));


              }).catchError((onError){
                //si on constate une erreur
                popUp();

              });
            }
            else
            {
              //si en mode connexion
              FirestoreHelper().Connect(mail.text, password.text).then((value){
                setState(() {
                  monUtilisateur = value;
                });
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return DashBoardView(mail: mail.text, password: password.text);
                    }
                ));
              }).catchError((onError){
                popUp();
              });
            }




          },
          child: const Text('Valider'),
        )

      ],
    );
  }
}

class Styles {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );
}
