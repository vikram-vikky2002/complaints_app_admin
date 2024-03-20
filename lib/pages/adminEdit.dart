import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app_admin/components/basePage.dart';
import 'package:complaint_app_admin/components/glassTextFields.dart';
import 'package:complaint_app_admin/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_validator/form_validator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AdminEditPage extends StatefulWidget {
  const AdminEditPage({super.key});

  @override
  State<AdminEditPage> createState() => _AdminEditPageState();
}

class _AdminEditPageState extends State<AdminEditPage> {
  TextEditingController title = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  User? user;

  reset() {
    title.clear();
  }

  @override
  void initState() {
    super.initState();
    user = FireAuth().currentUser;
  }

  removeAdmin(id) async {
    if (user!.email != id) {
      try {
        await FirebaseFirestore.instance
            .collection('admins')
            .doc(id)
            .delete()
            .then((value) {
          Fluttertoast.showToast(
            msg: 'Admin access removed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.redAccent,
            textColor: Colors.black,
            fontSize: 16.0,
          );
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
    } else {
      Fluttertoast.showToast(
        msg: 'Cannot Revoke your own Access',
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
    return BackgroundPage(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        "Add New Admin : ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                        ),
                      ),
                    ],
                  ),
                ),
                GlassTextField(
                  labelText: "Enter email",
                  validator: ValidationBuilder()
                      .required("This field is required")
                      .build(),
                  cont: title,
                ),
                const SizedBox(height: 16),
                RoundedLoadingButton(
                  onPressed: () async {
                    if (title.text == "") {
                      _btnController.error();
                      Timer(const Duration(seconds: 2), () {
                        _btnController.reset();
                      });

                      Fluttertoast.showToast(
                        msg: 'Please Enter Email ID',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.black,
                        fontSize: 16.0,
                      );
                      return;
                    }
                    try {
                      await FirebaseFirestore.instance
                          .collection('admins')
                          .doc(title.text)
                          .get()
                          .then((doc) async {
                        if (doc.exists) {
                          _btnController.error();
                          Timer(const Duration(seconds: 2), () {
                            _btnController.reset();
                          });
                          Fluttertoast.showToast(
                            msg: 'Admin Already Exists',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.black,
                            fontSize: 16.0,
                          );
                        } else {
                          await FirebaseFirestore.instance
                              .collection('admins')
                              .doc(title.text)
                              .set({
                            'created-on': DateTime.now(),
                            'added-by': user!.email,
                          });
                          _btnController.success();
                          reset();
                          Timer(const Duration(seconds: 2), () {
                            _btnController.reset();
                          });
                          print("New doc Created..");
                        }
                      });
                    } on FirebaseException catch (error) {
                      _btnController.error();
                      Timer(const Duration(seconds: 2), () {
                        _btnController.reset();
                      });
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
                  },
                  // {

                  //   Timer(const Duration(seconds: 2), () {
                  //     _btnController.success();
                  //   });
                  //   Timer(const Duration(seconds: 4), () {
                  //     _btnController.reset();
                  //   });
                  // },
                  controller: _btnController,
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Fonarto',
                      fontSize: 20,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 45),
                  child: Text(
                    "Admin List",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.53,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('admins')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            print('Admin Has Data');
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data!.docs.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            62, 255, 255, 255),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  snapshot.data!.docs[index].id,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => removeAdmin(
                                                snapshot.data!.docs[index].id),
                                            icon: const Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Text(
                                    "Empty",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            );
                          } else {
                            return const Text(
                              "Empty",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
