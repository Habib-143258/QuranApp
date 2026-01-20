import 'package:flutter/material.dart';
import 'package:quran_app/widgets/explore/explore_header_widget.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ExploreHeaderWidget(),
            Expanded(child: Center(child: Text('Explore content'))),
          ],
        ),
      ),
    );
  }
}
