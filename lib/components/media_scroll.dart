import 'package:flutter/material.dart';

class MediaScroll extends StatelessWidget {
  final String title;
  final List<String> posters;
  final bool showRanking;
  final double itemHeight;
  final double itemWidthFactor;

  const MediaScroll({
    super.key,
    required this.title,
    required this.posters,
    this.showRanking = true,
    this.itemHeight = 180,
    this.itemWidthFactor = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 8),

        // Scroll Row
        SizedBox(
          height: itemHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(posters.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      // Poster Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          posters[index],
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width *
                              itemWidthFactor,
                          height: itemHeight,
                        ),
                      ),

                      // Ranking Number (optional)
                      if (showRanking)
                        Positioned(
                          right: 6,
                          bottom: 6,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
