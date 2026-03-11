import 'package:flutter/material.dart';
import 'package:rateflix/components/media_scroll.dart';
import 'package:rateflix/services/user_service.dart';
import 'package:rateflix/tabs/pages/search_view.dart';
import 'package:rateflix/theme_data.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final double doublePadding = 32.0;
  final double padding = 16.0;

  final UserService userService = UserService();

  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isRatingsLoading = true;

  /// 🔥 Ratings gruppiert nach DB-Category
  Map<String, List<dynamic>> ratingsByCategory = {};

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // ---------------------------
  // USERDATEN
  // ---------------------------
  Future<void> loadUserData() async {
    try {
      final userID = await userService.getUserID();
      if (userID == null) {
        setState(() => isLoading = false);
        return;
      }

      final data = await userService.getUserData(userID);

      setState(() {
        userData = data;
        isLoading = false;
      });

      await loadUserRatings();
    } catch (e) {
      print('Fehler beim Laden der User-Daten: $e');
      setState(() => isLoading = false);
    }
  }

  // ---------------------------
  // RATINGS → NACH CATEGORY GRUPPIEREN
  // ---------------------------
  Future<void> loadUserRatings() async {
    try {
      final userID = await userService.getUserID();
      if (userID == null) return;

      final ratings = await userService.getUserRatings(userID);

      final Map<String, List<dynamic>> grouped = {};

      for (final rating in ratings) {
        final String category = (rating['category'] ?? 'Sonstiges').toString();

        grouped.putIfAbsent(category, () => []);
        grouped[category]!.add(rating);
      }

      setState(() {
        ratingsByCategory = grouped;
        isRatingsLoading = false;
      });

      // Debug
      grouped.forEach((cat, list) {
        print('Kategorie "$cat": ${list.length} Filme');
      });
    } catch (e) {
      print('Fehler beim Laden der Ratings: $e');
    }
  }

  // ---------------------------
  // POSTER (Platzhalter)
  // ---------------------------
  List<String> buildPosters(List<dynamic> ratings) {
    return ratings.map((r) {
      return "https://image.tmdb.org/t/p/w300_and_h450_bestv2/ooBGRQBdbGzBxAVfExiO8r7kloA.jpg";
    }).toList();
  }

  // ---------------------------
  // UI
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                        SizedBox(width: padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?['username'] ?? 'No username',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: const [
                                  _StatBlock(label: 'Ratings', value: '35'),
                                  SizedBox(width: 32),
                                  _StatBlock(label: 'Follower', value: '35'),
                                  SizedBox(width: 32),
                                  _StatBlock(label: 'Friends', value: '35'),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: doublePadding),

                    // SLIDER PRO CATEGORY
                    Expanded(
                      child: isRatingsLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView(
                              children: ratingsByCategory.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 32),
                                  child: MediaScroll(
                                    title: entry.key,
                                    items: entry
                                        .value, // 🔥 komplette Rating-Liste
                                    showRanking: true,
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
        ),

        // FAB
        floatingActionButton: SizedBox(
          height: 48,
          width: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchView(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 28,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------
// KLEINE HILFSKOMPONENTE
// ---------------------------
class _StatBlock extends StatelessWidget {
  final String label;
  final String value;

  const _StatBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(label),
      ],
    );
  }
}
