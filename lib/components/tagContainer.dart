import 'dart:ui';

import 'package:flutter/material.dart';

class TagContainer extends StatelessWidget {
  final String title;
  final int select;
  final int index;
  const TagContainer({
    super.key,
    required this.title,
    required this.index,
    required this.select,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: index == select
                  ? Border.all(width: 2, color: Colors.white)
                  : null,
              color: Colors.grey.shade200.withOpacity(0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Fonarto',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
