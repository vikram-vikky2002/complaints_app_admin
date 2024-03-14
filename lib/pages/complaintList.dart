import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app_admin/components/basePage.dart';
import 'package:complaint_app_admin/components/tagContainer.dart';
import 'package:complaint_app_admin/pages/showComplaint.dart';
import 'package:flutter/material.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  String tag = 'all';
  int fill = 0;
  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      child: SafeArea(
        child: Column(
          children: [
            const Text(
              'Complaints List',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: 'Fonarto',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tag = 'all';
                        fill = 0;
                      });
                    },
                    child: TagContainer(
                      title: 'All',
                      select: fill,
                      index: 0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tag = 'true';
                        fill = 1;
                      });
                    },
                    child: TagContainer(
                      title: 'Checked',
                      select: fill,
                      index: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tag = 'false';
                        fill = 2;
                      });
                    },
                    child: TagContainer(
                      title: 'Unchecked',
                      index: 2,
                      select: fill,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.83,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('complaints')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!.docs;
                      final filteredEvents = data.where((event) {
                        if (tag == "all") {
                          return true;
                        } else if (event.data()['status'].toString() == tag) {
                          print('true');
                          return true;
                        } else if (event.data()['status'].toString() == tag) {
                          print('false');
                          return true;
                        } else {
                          return false;
                        }
                      }).toList();
                      return ListView.builder(
                          itemCount: filteredEvents.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            if (filteredEvents.isNotEmpty) {
                              Map<String, dynamic> data =
                                  filteredEvents[index].data();
                              return Padding(
                                padding: const EdgeInsets.all(15),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ComplaintDetails(data: data)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          62, 255, 255, 255),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Complaint ID : ${data["id"]}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${data["title"]}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontFamily: 'Fonarto',
                                            ),
                                          ),
                                          Text(
                                            '${data["description"]}',
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text('${data["status"]}')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'No Complaints Found',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
