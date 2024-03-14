import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app_admin/pages/showComplaint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class RegisteredComplaints extends StatefulWidget {
  const RegisteredComplaints({super.key, required this.user});
  final User? user;

  @override
  State<RegisteredComplaints> createState() => _RegisteredComplaintsState();
}

class _RegisteredComplaintsState extends State<RegisteredComplaints> {
  Stream<List<Map<String, dynamic>>> fetchDataStream(eventIDs) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    StreamController<List<Map<String, dynamic>>> controller =
        StreamController();

    List<Map<String, dynamic>> result = [];

    for (String documentId in eventIDs) {
      try {
        DocumentSnapshot documentSnapshot =
            await firestore.collection('complaints').doc(documentId).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          result.add(data);
        } else {
          print('Document $documentId does not exist.');
        }
      } catch (e) {
        print('Error fetching document $documentId: $e');
      }
    }

    // Add the result to the stream
    controller.add(result);

    // Close the stream
    controller.close();

    // Yield the stream
    yield* controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          color: const Color.fromARGB(155, 255, 255, 255),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Registered Complaints",
              style: TextStyle(
                  fontSize: 23, fontFamily: "Fonarto", color: Colors.black),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.user?.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text(
                      "No Complaints Registered Yet.",
                      style: TextStyle(color: Colors.black),
                    );
                  } else {
                    var document = snapshot.data!.data();
                    List eventIDs = document!['complaints'] ?? [];
                    return Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                            stream: fetchDataStream(eventIDs),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LoadingIndicator(
                                  indicatorType:
                                      Indicator.ballClipRotateMultiple,
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                if (eventIDs.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ListView.builder(
                                      itemCount: snapshot.data?.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: InkWell(
                                            onTap: () {
                                              var det = snapshot.data![index];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ComplaintDetails(
                                                          data: det),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'ID : ${snapshot.data![index]['id']}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${snapshot.data![index]['title']}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: snapshot.data![index]
                                                            ['status']
                                                        ? Colors.green
                                                        : Colors.grey,
                                                    child: Row(
                                                      children: [
                                                        snapshot.data![index]
                                                                ['status']
                                                            ? const Icon(
                                                                Icons.check)
                                                            : const Icon(
                                                                Icons.close),
                                                        Text(snapshot.data![
                                                                index]['status']
                                                            ? "Checked"
                                                            : "Not Checked"),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return const Text(
                                    "No Complaints Registered Yet.",
                                    style: TextStyle(color: Colors.black),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
