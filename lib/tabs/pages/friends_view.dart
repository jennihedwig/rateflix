import 'package:flutter/material.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _HomeViewState();
}

class _HomeViewState extends State<FriendsView> {
  final double doublePadding = 32.0;
  final double padding = 16.0;
  final double innerPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Welcome message
              const Text(
                'Welcome Jenni',
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              Text(
                'You have 6 tasks due today',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w100,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: doublePadding),
            ],
          ),
        ),
      ),
    );
  }
}
