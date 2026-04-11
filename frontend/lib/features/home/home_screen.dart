import 'package:flutter/material.dart';
import '../directory/directory_screen.dart';
import 'crowd_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CrowdWidget(),
        Expanded(child: DirectoryScreen()),
      ],
    );
  }
}
