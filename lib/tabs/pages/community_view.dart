import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() {
    return _CalendarViewState();
  }
}

class _CalendarViewState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text("Community"),
      ),
    );
  }
}
