import 'package:complaint_app_admin/components/basePage.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

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
