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
  final double innerPadding = 8.0;

  UserService userService = UserService();

  Map<String, dynamic>? userData; // ✅ hier speichern wir die Daten
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('Init Stat ProfileView');
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      print('Starte loadUserData...');
      final userID = await userService.getUserID();
      print('userID: $userID');

      if (userID == null) {
        print('Kein UserID gefunden!');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final data = await userService.getUserData(userID);
      print('userData: $data');

      setState(() {
        userData = data; // State aktualisieren
        isLoading = false; // Loading ausblenden
      });

      await loadUserRatings();
    } catch (e) {
      print('Fehler beim Laden der User-Daten: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadUserRatings() async {
    try {
      print('Starte loadUserRatings...');

      final userID = await userService.getUserID();
      if (userID == null) {
        print('Keine UserID gefunden – Ratings nicht geladen');
        return;
      }

      final ratings = await userService.getUserRatings(userID);

      print('User Ratings (${ratings.length}):');
      for (final rating in ratings) {
        print('Rating: $rating');
      }
    } catch (e) {
      print('Fehler beim Laden der Ratings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);

    final List<String> topMovies = [
      "https://image.tmdb.org/t/p/w300_and_h450_bestv2/ooBGRQBdbGzBxAVfExiO8r7kloA.jpg",
      "https://image.tmdb.org/t/p/w130_and_h195_bestv2/keXRM5UccYbolBbvndx1hTWsOVi.jpg",
      "https://image.tmdb.org/t/p/w116_and_h174_face/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg",
      "https://image.tmdb.org/t/p/w116_and_h174_face/klL4yhwiU8aF4AuF5dCfJA9sRnS.jpg",
      "https://image.tmdb.org/t/p/w116_and_h174_face/7J5sJONPZuyNH9SuLYi4XvVUujk.jpg",
      "https://image.tmdb.org/t/p/w116_and_h174_face/b3vl6wV1W8PBezFfntKTrhrehCY.jpg",
      "https://image.tmdb.org/t/p/w130_and_h195_bestv2/ekaa7YjGPTkFLcPhwWXTnARuCEU.jpg",
      "https://image.tmdb.org/t/p/w130_and_h195_bestv2/ifo31fMWLmyOVpdak9K0kY4jldQ.jpg",
      "https://image.tmdb.org/t/p/w116_and_h174_face/vQiryp6LioFxQThywxbC6TuoDjy.jpg",
      "https://image.tmdb.org/t/p/w130_and_h195_bestv2/bJs8Y6T88NcgksxA8UaVl4YX8p8.jpg",
    ];

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator()) // Loading
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                        SizedBox(
                          width: padding,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?['username'] ?? 'No username',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: padding / 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '35',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text('Ratings'),
                                    ],
                                  ),
                                  SizedBox(
                                    width: doublePadding,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '35',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text('Follower'),
                                    ],
                                  ),
                                  SizedBox(
                                    width: doublePadding,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '35',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text('Friends'),
                                    ],
                                  ),
                                  SizedBox(
                                    width: padding,
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: doublePadding),
                    // TOP 10 Scroll
                    MediaScroll(
                      title: 'Top 10 Filme',
                      posters: topMovies,
                      showRanking: true,
                    )
                  ],
                ),
        ),
        floatingActionButton: SizedBox(
          height: 48,
          width: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SearchView()),
              );
            },
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 28,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
