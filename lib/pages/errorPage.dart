import 'dart:async';

import 'package:complaint_app_admin/components/basePage.dart';
import 'package:complaint_app_admin/pages/loginPage.dart';
import 'package:complaint_app_admin/services/auth.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  checkUser() {
    FireAuth().signOut();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(),
          SizedBox(
            // height: 170,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Image.asset('assets/icons/error.png'),
          ),
          const Text(
            'Admin Access Denied !',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 150),
        ],
      )),
    );
  }
}
