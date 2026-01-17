import 'package:flutter/material.dart';

class WatchListView extends StatefulWidget {
  const WatchListView({super.key});

  @override
  State<WatchListView> createState() {
    return _WatchListViewState();
  }
}

class _WatchListViewState extends State<WatchListView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text("Watchlist"),
      ),
    );
  }
}
