import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app_admin/components/basePage.dart';
import 'package:complaint_app_admin/pages/profilePage.dart';
import 'package:complaint_app_admin/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminCheck extends StatefulWidget {
  const AdminCheck({super.key});

  @override
  State<AdminCheck> createState() => _AdminCheckState();
}

class _AdminCheckState extends State<AdminCheck> {
  User? user;

  @override
  void initState() {
    user = FireAuth().currentUser;
    super.initState();
  }

  checkUser() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(user!.email)
        .get()
        .then((doc) {
      if (doc.exists) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(userData: user)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      child: SafeArea(
        child: Column(
          children: [
            Row(),
          ],
        ),
      ),
    );
  }
}
