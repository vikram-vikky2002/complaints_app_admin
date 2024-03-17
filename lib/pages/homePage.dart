import 'dart:async';
import 'package:complaint_app_admin/components/basePage.dart';
import 'package:complaint_app_admin/pages/adminEdit.dart';
import 'package:complaint_app_admin/pages/complaintList.dart';
import 'package:complaint_app_admin/pages/profilePage.dart';
import 'package:complaint_app_admin/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _timeString;
  User? user;
  // Position? location;

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    // getLocation();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    user = FireAuth().currentUser;
    super.initState();
  }

  // getLocation() async {
  //   location = await _determinePosition();
  //   print("Location : $location");
  // }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy\nhh:mm:ss a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _timeString ?? "",
                      style: const TextStyle(
                        fontFamily: 'Fonarto',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Hero(
                    tag: "Logo",
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Image.asset('assets/icons/PoliceLogo.png'),
                    ),
                  ),
                  Text(
                    'Police Department\nKaraikal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Fonarto',
                      fontSize: MediaQuery.of(context).size.width * 0.068,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                'Admin App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'Fonarto',
                  fontSize: MediaQuery.of(context).size.width * 0.068,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminEditPage()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.11,
                          child: Image.asset('assets/icons/admin.png'),
                        ),
                        const Text(
                          'Admin\nManagement',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: 'Fonarto',
                            // fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ComplaintsPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.11,
                          child: Image.asset('assets/icons/issues.png'),
                        ),
                        const Text(
                          'Complaints',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: 'Fonarto',
                            // fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(userData: user),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.11,
                          child: Image.asset('assets/icons/profile.png'),
                        ),
                        const Text(
                          'Profile',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: 'Fonarto',
                            // fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => FireAuth().signOut(),
                      child: Container(
                        height: 40,
                        // width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: SizedBox(
                                width: 40,
                                child: Image.asset('assets/icons/SignOut.png'),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // const Padding(
              //   padding: EdgeInsets.all(13),
              //   child: Text(
              //     'Made by AppAlchemy 📱',
              //     textAlign: TextAlign.center,
              //     softWrap: true,
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 15,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
