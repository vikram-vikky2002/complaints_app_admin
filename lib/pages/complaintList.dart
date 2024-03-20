import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app_admin/components/basePage.dart';
import 'package:complaint_app_admin/components/glassTextFields.dart';
import 'package:complaint_app_admin/components/tagContainer.dart';
import 'package:complaint_app_admin/pages/showComplaint.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  String tag = 'all';
  int fill = 0;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      child: SafeArea(
        child: SingleChildScrollView(
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                child: GlassTextField(
                  labelText: "Search Title / ID / Location",
                  // validator: ValidationBuilder().build(),
                  cont: _searchController,
                ),
              ),
              SizedBox(
                // color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.73,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('complaints')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          var data = snapshot.data!.docs;
                          final filteredEvents = data.where((event) {
                            if (tag == "all") {
                              return true;
                            } else if (event.data()['status'].toString() ==
                                tag) {
                              print('true');
                              return true;
                            } else if (event.data()['status'].toString() ==
                                tag) {
                              print('false');
                              return true;
                            } else {
                              return false;
                            }
                          }).toList();
                          return ListView.builder(
                              itemCount: filteredEvents.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                if (kDebugMode) {
                                  print("filteredEvents : $filteredEvents");
                                }
                                if (filteredEvents.isNotEmpty) {
                                  Map<String, dynamic> data =
                                      filteredEvents[index].data();
                                  bool matchesSearchQuery = data['title']
                                          .toLowerCase()
                                          .contains(_searchController.text
                                              .toLowerCase()) ||
                                      data['id'].toString().contains(
                                          _searchController.text
                                              .toLowerCase()) ||
                                      data['location'].toString().contains(
                                          _searchController.text.toLowerCase());
                                  if (_searchController.text.isEmpty ||
                                      matchesSearchQuery) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 4,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ComplaintDetails(
                                                          data: data)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(
                                                        data["date"].toDate(),
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
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
                                return null;
                              });
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              'No Complaints Found',
                              style: TextStyle(
                                color: Color.fromARGB(255, 210, 209, 209),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
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
      ),
    );
  }
}
