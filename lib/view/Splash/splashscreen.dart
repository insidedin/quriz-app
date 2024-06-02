import 'package:quriz/utils/Function/function.dart';
import 'package:flutter/material.dart';
import 'package:quriz/view/Login/login.dart';
import 'package:quriz/view/Widget/appbarview.dart';
import 'package:quriz/view/Widget/textview.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    navigationReplaceDelay(context, const Login(), 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarSplash(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 100, right: 100),
            child: Image.asset('assets/images/splash/logo.png'),
          ),
          const SizedBox(height: 100),
          Container(
            margin: const EdgeInsets.only(top: 150),
            child: textView("Qur'an Memorization", 15, Colors.black,
                FontWeight.bold, TextAlign.start, const EdgeInsets.all(0)),
          )
        ],
      ),
    );
  }
}
