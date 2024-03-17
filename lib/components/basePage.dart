import 'package:flutter/material.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({super.key, required this.child});

  final Widget child;

  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/background/background3.jpg'),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(169, 74, 5, 0),
                  Color.fromARGB(174, 11, 0, 62),
                ],
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
