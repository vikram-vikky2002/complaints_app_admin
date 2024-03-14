import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_app_admin/components/basePage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ComplaintDetails extends StatefulWidget {
  const ComplaintDetails({super.key, required this.data});

  final Map data;

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  @override
  Widget build(BuildContext context) {
    var titleStyle = const TextStyle(
      color: Colors.white,
      fontFamily: 'Fonarto',
      fontSize: 22,
    );

    var descStyle = const TextStyle(
      color: Colors.white,
      // fontFamily: 'Fonarto',
      fontSize: 16,
    );

    var timeStyle = const TextStyle(
      color: Colors.white,
      // fontFamily: 'Fonarto',
      fontSize: 13,
    );

    return BackgroundPage(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: InkWell(
                      onTap: () async {
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
                        try {
                          await FirebaseFirestore.instance
                              .collection('complaints')
                              .doc(widget.data['id'])
                              .delete()
                              .then((value) async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.data['userID'])
                                .update({
                              'complaints':
                                  FieldValue.arrayRemove([widget.data['id']])
                            }).then((value) {
                              Fluttertoast.showToast(
                                msg: 'Complaint Deleted',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                            });
                            Navigator.pop(context);
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
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.27,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(111, 231, 71, 71),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 3),
                            Text(
                              "Delete",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${widget.data['title']}',
                style: titleStyle,
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  '${widget.data['description']}',
                  textAlign: TextAlign.justify,
                  style: descStyle,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'Submitted on : ${DateFormat('dd/MM/yyyy hh:mm a').format(widget.data['date'].toDate())}',
                  textAlign: TextAlign.justify,
                  style: timeStyle,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 300,
                child: Image.network(
                  widget.data['images'],
                  fit: BoxFit.contain,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
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
                      try {
                        await FirebaseFirestore.instance
                            .collection('complaints')
                            .doc(widget.data['id'])
                            .update({'status': true}).then((value) {
                          setState(() {
                            widget.data['status'] = true;
                          });

                          Fluttertoast.showToast(
                            msg: 'Updated',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.greenAccent,
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

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: widget.data['status'] ? 3 : 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color:
                            widget.data['status'] ? Colors.green : Colors.grey,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              Text(
                                "Checked",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
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
                      try {
                        await FirebaseFirestore.instance
                            .collection('complaints')
                            .doc(widget.data['id'])
                            .update({'status': false}).then((value) {
                          setState(() {
                            widget.data['status'] = false;
                          });
                          Fluttertoast.showToast(
                            msg: 'Updated',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.greenAccent,
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
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: !widget.data['status'] ? 3 : 0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color:
                            !widget.data['status'] ? Colors.red : Colors.grey,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              Text(
                                "Not Checked",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
