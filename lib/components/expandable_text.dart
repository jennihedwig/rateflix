import 'package:flutter/material.dart';
import 'package:rateflix/theme_data.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText(this.text, {super.key});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: expanded ? null : 3,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => expanded = !expanded),
          child: Text(
            expanded ? "weniger anzeigen" : "mehr anzeigen",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
