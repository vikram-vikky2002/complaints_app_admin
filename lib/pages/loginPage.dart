import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app_admin/components/basePage.dart';
import 'package:complaint_app_admin/pages/errorPage.dart';
import 'package:complaint_app_admin/pages/homePage.dart';
import 'package:complaint_app_admin/services/auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phone = TextEditingController();
  String errorText = "";
  bool valid = false;
  bool admin = false;
  late StreamSubscription internet;
  var isDeviceConnected = false, isAlertSet = false;

  @override
  void initState() {
    super.initState();
    getConnectivity();
  }

  showDialogBox() => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Check your internet connection'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'cancel');
                setState(() {
                  isAlertSet = false;
                });
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected) {
                  showDialogBox();
                  setState(() {
                    isAlertSet = true;
                  });
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  getConnectivity() =>
      internet = Connectivity().onConnectivityChanged.listen((event) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          showDialogBox();
          setState(() {
            isAlertSet = true;
          });
        }
      });

  checkUser(user) async {
    try {
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(user!.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          if (kDebugMode) {
            print('Admin...');
          }
        } else {
          if (kDebugMode) {
            print('user: ${user.email}');
            print('Not Admin...');
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ErrorPage(),
            ),
          );
        }
      });
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(
        msg: 'Error : $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FireAuth().authStateChanges,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return BackgroundPage(
                child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Center(
                  //   child: Text(
                  //     'Signin Page',
                  //     style: TextStyle(
                  //       fontSize: 25,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Hero(
                    tag: "Logo",
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.asset('assets/icons/PoliceLogo.png'),
                    ),
                  ),
                  const Text(
                    'ADMIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Ethnocentric',
                      fontSize: 26,
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        FireAuth().signInWithGoogle().whenComplete(() async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Scaffold(
                                        backgroundColor: Colors.black,
                                        body: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: LoadingIndicator(
                                                  indicatorType: Indicator
                                                      .ballClipRotateMultiple,
                                                ),
                                              ),
                                              Text(
                                                'Loading...',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )));
                          User? user = FireAuth().currentUser;
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.email)
                                .get()
                                .then((doc) async {
                              if (doc.exists) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.email)
                                    .update({
                                  'lastSignin': DateTime.now(),
                                });
                                if (kDebugMode) {
                                  print("Exist..");
                                }
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.email)
                                    .set({});
                                if (kDebugMode) {
                                  print("New doc Created..");
                                }
                              }
                            }).whenComplete(() {
                              checkUser(user);
                            });
                          } on FirebaseException catch (error) {
                            if (kDebugMode) {
                              print("Errro : $error");
                            }
                          }

                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: SizedBox(
                                width: 60,
                                child: Image.asset('assets/icons/google.png'),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                'Sign In with Google',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      valid ? "" : errorText,
                      // errorText ?? "",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ));
          } else {
            // User? user = FireAuth().currentUser;
            return const HomePage();
          }
        });
  }
}
