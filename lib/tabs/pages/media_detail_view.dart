import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rateflix/components/expandable_text.dart';
import 'package:rateflix/services/media_service.dart';
import 'package:rateflix/services/user_service.dart';
import 'package:rateflix/theme_data.dart';
import 'package:intl/intl.dart';

class MediaDetailView extends StatelessWidget {
  final Map<String, dynamic> media;

  const MediaDetailView({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final title = media['title'] ?? media['name'] ?? "Unbekannt";
    final overview = media['overview'] ?? "";
    final posterPath = media['poster_path'];
    final type = media['media_type'];
    int? selectedCategoryIndex;
    String? selectedCategory;
    double starSize = 52;
    UserService userService = UserService();
    MediaService mediaService = MediaService();

    String formatDate(String input) {
      final DateTime parsed = DateTime.parse(input);
      final DateFormat formatter = DateFormat('yyyy');
      return formatter.format(parsed);
    }

    final mediaType = media['media_type'];
    final rawDate =
        mediaType == 'movie' ? media['release_date'] : media['first_air_date'];
    final releasedate = rawDate is String ? formatDate(rawDate) : "–";

    //final releasedate = formatDate(media['release_date']);

    final List<String> options = [
      "Top 10 Filme",
      "Top 10 Serien",
      "Lieblingsweihnachts Filme",
      "Cozy Filme",
      "Sehr schlecht",
    ];

    void saveRating(rating, category) async {
      var userID = await userService.getUserID();

      print('Create Project');
      Map<String, dynamic> data = {
        "userID": userID,
        "mediaID": media['id'],
        "rating": rating,
        "type": mediaType,
        "category": category
      };
      print('rating Data: $data');

      await mediaService.saveRating(data).then((value) {
        print("test");
        return;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Posterbild
              if (posterPath != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w500$posterPath",
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Titel
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Row(
                children: [Text(releasedate)],
              ),
              const SizedBox(height: 8),

              // Beschreibung
              ExpandableText(overview),

              SizedBox(
                height: 16,
              ),
              // Freunde
              Text('5 Freunde haben diesen Film bewertet')
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Bewerten",
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) {
                        double selectedRating = 0;

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 16,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        16,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    "Wie fandest du diesen Film?",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 16),

                                  // ⭐ Sterne
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(5, (index) {
                                          IconData icon;
                                          if (selectedRating >= index + 1) {
                                            icon = Icons.star;
                                          } else if (selectedRating >=
                                              index + 0.5) {
                                            icon = Icons.star_half;
                                          } else {
                                            icon = Icons.star_border;
                                          }

                                          return GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTapDown: (details) {
                                              final dx =
                                                  details.localPosition.dx;
                                              final newRating = index +
                                                  (dx > starSize / 2 ? 1 : 0.5);
                                              setState(() {
                                                selectedRating = newRating
                                                    .clamp(0.5, 5.0)
                                                    .toDouble();
                                                ;
                                              });
                                            },
                                            child: Icon(
                                              icon,
                                              size: starSize,
                                              color: Colors.amber,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // 📂 Kategorie Feld
                                  GestureDetector(
                                    onTap: () {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) {
                                          int tempIndex = selectedCategory ==
                                                  null
                                              ? 0
                                              : options
                                                  .indexOf(selectedCategory!);

                                          return Container(
                                            height: 260,
                                            color: CupertinoColors
                                                .systemBackground,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 44,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    child: const Text("Fertig"),
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedCategory =
                                                            options[tempIndex];
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: CupertinoPicker(
                                                    itemExtent: 36,
                                                    scrollController:
                                                        FixedExtentScrollController(
                                                      initialItem: tempIndex,
                                                    ),
                                                    onSelectedItemChanged:
                                                        (index) {
                                                      tempIndex = index;
                                                    },
                                                    children: options
                                                        .map((e) => Center(
                                                              child: Text(e),
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selectedCategory ??
                                                "Kategorie auswählen",
                                            style: TextStyle(
                                              color: selectedCategory == null
                                                  ? Colors.grey
                                                  : Colors.black,
                                            ),
                                          ),
                                          const Icon(
                                            CupertinoIcons.chevron_down,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // ✍️ Kommentar
                                  TextField(
                                    minLines: 3,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: "Kommentar (optional)",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // ✅ Absenden
                                  ElevatedButton(
                                    onPressed: selectedRating == 0 ||
                                            selectedCategory == null
                                        ? null
                                        : () {
                                            debugPrint(
                                                "Rating: $selectedRating, Kategorie: $selectedCategory");
                                            debugPrint("Save Rating to DB");
                                            saveRating(selectedRating,
                                                selectedCategory);

                                            Navigator.pop(context);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          const Size(double.infinity, 48),
                                      backgroundColor: theme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      "Absenden",
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 🔖 Bookmark Button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Save to Watchlist");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(CupertinoIcons.bookmark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
