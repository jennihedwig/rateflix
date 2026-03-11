import 'package:flutter/material.dart';
import 'package:rateflix/tabs/pages/media_detail_view.dart';

class MediaScroll extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final bool showRanking;
  final double itemHeight;
  final double itemWidthFactor;

  const MediaScroll({
    super.key,
    required this.title,
    required this.items,
    this.showRanking = true,
    this.itemHeight = 180,
    this.itemWidthFactor = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        // SCROLL
        SizedBox(
          height: itemHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];

                final posterUrl =
                    "https://image.tmdb.org/t/p/w300${item['imagePath']}";

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MediaDetailView(
                            mediaID: item['mediaID'] is int
                                ? item['mediaID']
                                : int.parse(item['mediaID'].toString()),
                            mediaType: item['type'],
                            posterPath: item['imagePath'],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            posterUrl,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width *
                                itemWidthFactor,
                            height: itemHeight,
                          ),
                        ),
                        if (showRanking)
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
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
