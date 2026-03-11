import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rateflix/components/expandable_text.dart';
import 'package:rateflix/services/media_service.dart';
import 'package:rateflix/services/user_service.dart';
import 'package:rateflix/theme_data.dart';

class MediaDetailView extends StatefulWidget {
  final int mediaID;
  final String mediaType; // movie | tv
  final String? posterPath; // optional (für sofortiges Anzeigen)

  const MediaDetailView({
    super.key,
    required this.mediaID,
    required this.mediaType,
    this.posterPath,
  });

  @override
  State<MediaDetailView> createState() => _MediaDetailViewState();
}

class _MediaDetailViewState extends State<MediaDetailView> {
  final MediaService mediaService = MediaService();
  final UserService userService = UserService();

  Map<String, dynamic>? media;
  bool isLoading = true;

  double starSize = 52;
  double selectedRating = 0;
  String? selectedCategory;
  int? selectedRanking;

  final List<String> options = [
    "Top 10 Filme",
    "Top 10 Serien",
    "Lieblingsweihnachts Filme",
    "Cozy Filme",
    "Sehr schlecht",
  ];

  @override
  void initState() {
    super.initState();
    loadMediaDetails();
  }

  Future<void> loadMediaDetails() async {
    try {
      final data = await mediaService.getMediaDetails(
        widget.mediaID,
        widget.mediaType,
      );

      setState(() {
        media = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Fehler beim Laden der Media-Details: $e');
      setState(() => isLoading = false);
    }
  }

  String formatYear(String? input) {
    if (input == null || input.isEmpty) return "–";
    final DateTime parsed = DateTime.parse(input);
    return DateFormat('yyyy').format(parsed);
  }

  Future<void> saveRating() async {
    final userID = await userService.getUserID();
    if (userID == null) return;

    final String mediaName = media?['title'] ?? media?['name'] ?? "Unbekannt";

    final data = {
      "userID": userID,
      "mediaID": widget.mediaID,
      "rating": selectedRating,
      "name": mediaName,
      "type": widget.mediaType,
      "category": selectedCategory,
      "ranking": selectedRanking,
      "imagePath": media?['poster_path'] ?? widget.posterPath,
    };

    await mediaService.saveRating(data);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && media == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (media == null) {
      return const Scaffold(
        body: Center(child: Text("Keine Daten gefunden")),
      );
    }

    final title = media!['title'] ?? media!['name'] ?? "Unbekannt";
    final overview = media!['overview'] ?? "";
    final posterPath = media!['poster_path'] ?? widget.posterPath;

    final rawDate = widget.mediaType == 'movie'
        ? media!['release_date']
        : media!['first_air_date'];

    final releaseYear = formatYear(rawDate);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(releaseYear),
            const SizedBox(height: 12),
            ExpandableText(overview),
            const SizedBox(height: 16),
            const Text("5 Freunde haben diesen Film bewertet"),
          ],
        ),
      ),

      /// ⭐⭐⭐⭐⭐ RATING BUTTON
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
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) {
                        return StatefulBuilder(
                          builder: (context, setModalState) {
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
                                children: [
                                  const Text(
                                    "Wie fandest du diesen Film?",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  /// ⭐ STAR RATING
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        onTapDown: (details) {
                                          final dx = details.localPosition.dx;
                                          final newRating = index +
                                              (dx > starSize / 2 ? 1 : 0.5);

                                          setModalState(() {
                                            selectedRating = newRating
                                                .clamp(0.5, 5.0)
                                                .toDouble();
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

                                  const SizedBox(height: 16),

                                  /// 📂 CATEGORY PICKER
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
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    child: const Text("Fertig"),
                                                    onPressed: () {
                                                      setModalState(() {
                                                        selectedCategory =
                                                            options[tempIndex];
                                                        selectedRanking =
                                                            null; // reset ranking
                                                      });
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: CupertinoPicker(
                                                    itemExtent: 36,
                                                    onSelectedItemChanged:
                                                        (index) {
                                                      tempIndex = index;
                                                    },
                                                    children: options
                                                        .map((e) => Center(
                                                            child: Text(e)))
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
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        selectedCategory ??
                                            "Kategorie auswählen",
                                        style: TextStyle(
                                          color: selectedCategory == null
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// 🥇 RANKING PICKER (nur wenn Kategorie gewählt)
                                  if (selectedCategory != null) ...[
                                    const SizedBox(height: 12),
                                    GestureDetector(
                                      onTap: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (_) {
                                            int tempRanking =
                                                selectedRanking ?? 1;

                                            return Container(
                                              height: 260,
                                              color: CupertinoColors
                                                  .systemBackground,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 44,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16),
                                                    child: CupertinoButton(
                                                      padding: EdgeInsets.zero,
                                                      child:
                                                          const Text("Fertig"),
                                                      onPressed: () {
                                                        setModalState(() {
                                                          selectedRanking =
                                                              tempRanking;
                                                        });
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: CupertinoPicker(
                                                      itemExtent: 36,
                                                      scrollController:
                                                          FixedExtentScrollController(
                                                        initialItem:
                                                            tempRanking - 1,
                                                      ),
                                                      onSelectedItemChanged:
                                                          (index) {
                                                        tempRanking = index + 1;
                                                      },
                                                      children: List.generate(
                                                        10,
                                                        (i) => Center(
                                                          child: Text(
                                                              "Platz ${i + 1}"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 14),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade400),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          selectedRanking != null
                                              ? "Platz $selectedRanking"
                                              : "Platz in der Kategorie wählen",
                                          style: TextStyle(
                                            color: selectedRanking == null
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 16),

                                  /// ✅ SUBMIT
                                  ElevatedButton(
                                    onPressed: selectedRating == 0 ||
                                            selectedCategory == null ||
                                            selectedRanking == null
                                        ? null
                                        : () async {
                                            await saveRating();
                                            Navigator.pop(context);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          const Size(double.infinity, 48),
                                      backgroundColor: theme.primaryColor,
                                    ),
                                    child: Text(
                                      "Absenden",
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
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
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Save to Watchlist");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
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
