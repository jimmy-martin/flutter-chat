import 'package:flutter_chat/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/customers_list.dart';
import 'package:flutter_chat/widgets/mydrawer.dart';

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
  int indexCurrent = 1;
  PageController controllerPage = PageController(initialPage: 1);
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
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Person"),
          BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit_outlined), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.back_hand), label: "New"),
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
        Text("Deuxième page"),
        Text("Troisème page"),
      ],
    );
  }
}
