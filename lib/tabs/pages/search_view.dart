import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rateflix/services/media_service.dart';
import 'package:rateflix/tabs/pages/media_detail_view.dart';
import 'package:rateflix/tabs/pages/profile_view.dart';
import 'package:rateflix/theme_data.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final mediaService = MediaService();
  final TextEditingController _controller = TextEditingController();
  final double doublePadding = 32.0;
  final double padding = 16.0;
  final double innerPadding = 8.0;

  List<dynamic> _results = [];
  bool _isLoading = false;
  String _error = "";

  Future<void> _search(String query) async {
    setState(() {
      _isLoading = true;
      _error = "";
    });

    try {
      final results = await mediaService.searchMedia(query);
      setState(() {
        _results = results;
      });
    } catch (e) {
      setState(() {
        _error = "Fehler bei der Suche: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero, // keine Extra-Padding
                    minSize: 0, // minimale Größe
                    child: const Icon(
                      CupertinoIcons.back, // das iOS-Back Icon
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileView()),
                      );
                    },
                  ),
                  SizedBox(
                    width: padding,
                  ),
                  Expanded(
                    child: CupertinoSearchTextField(
                      controller: _controller,
                      placeholder: 'Search',
                      onSubmitted: _search,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Ladeindikator
              if (_isLoading) const CircularProgressIndicator(),

              // Fehleranzeige
              if (_error.isNotEmpty)
                Text(_error, style: const TextStyle(color: Colors.red)),

              // Ergebnisse
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final item = _results[index];
                    final posterPath = item['poster_path'];
                    final backdropPath = item['backdrop_path'];

                    // Bild auswählen: Poster > Backdrop > Fallback
                    String? imagePath;
                    if (posterPath != null) {
                      imagePath = posterPath;
                    } else if (backdropPath != null) {
                      imagePath = backdropPath;
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => MediaDetailView(media: item)),
                        );
                      },
                      child: imagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w342$imagePath",
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              color: Colors.grey,
                              child: const Icon(Icons.movie, size: 40),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
