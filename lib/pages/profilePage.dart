import 'package:complaint_app_admin/components/basePage.dart';
import 'package:complaint_app_admin/components/registeredComplaints.dart';
import 'package:complaint_app_admin/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();

    user = FireAuth().currentUser;
    // FireAuth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
              const SizedBox(height: 20),
              Hero(
                tag: "Logo",
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset('assets/icons/user.png'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                user!.displayName ?? "...",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
              Text(
                user!.email ?? "...",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),
              RegisteredComplaints(user: user)
            ],
          ),
        ),
      ),
    );
  }
}
