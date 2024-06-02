import 'package:flutter/material.dart';
import 'package:quriz/utils/Function/function.dart';
import 'package:quriz/view/Home/home.dart';
import 'package:quriz/view/Widget/appbarview.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarProfile(() => navigationPush(context, const Home())));
  }
}
