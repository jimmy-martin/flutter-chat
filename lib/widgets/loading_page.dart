import 'package:flutter/material.dart';
import 'package:flutter_chat/main.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )
      ..forward()
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MyHomePage(title: "Hello World");
          }));
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/welcome.json"),
          ],
        ),
      ),
    );
  }
}
