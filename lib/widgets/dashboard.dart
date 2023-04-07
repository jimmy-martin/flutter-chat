import 'package:flutter_chat/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/customers_list.dart';
import 'package:flutter_chat/widgets/favorites_list.dart';
import 'package:flutter_chat/widgets/mydrawer.dart';
import 'package:flutter_chat/widgets/new_features_list.dart';

class DashBoard extends StatefulWidget {
  String mail;
  String password;

  DashBoard({Key? key, required this.mail, required this.password})
      : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  //variable
  int indexCurrent = 0;
  PageController controllerPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: MyDrawer()),
      appBar: AppBar(
        title: Text(myUser.fullName),
      ),
      body: bodyPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexCurrent,
        onTap: (value) {
          setState(() {
            indexCurrent = value;
            controllerPage.jumpToPage(value);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Personnes"),
          BottomNavigationBarItem(
              icon: Icon(Icons.star, color: Colors.yellow), label: "Favoris"),
          BottomNavigationBarItem(
              icon: Icon(Icons.new_releases), label: "Nouveautés"),
        ],
      ),
    );
  }

  Widget bodyPage() {
    return PageView(
      controller: controllerPage,
      onPageChanged: (value) {
        setState(() {
          controllerPage.jumpToPage(value);
          indexCurrent = value;
        });
      },
      children: const [
        CustomersList(),
        FavoritesList(),
        NewFeaturesList(),
      ],
    );
  }
}
