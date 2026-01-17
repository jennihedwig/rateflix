import 'package:flutter/material.dart';
import 'package:rateflix/tabs/pages/friends_view.dart';
import 'package:rateflix/tabs/pages/profile_view.dart';
import 'package:rateflix/tabs/pages/watchlist_view.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final _profileKey =
      GlobalKey<ProfileViewState>(); // ✅ GlobalKey für ProfileView

  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildOffstageNavigator(0, ProfileView(key: _profileKey)),
          _buildOffstageNavigator(1, const FriendsView()),
          _buildOffstageNavigator(2, const WatchListView()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() => _selectedPageIndex = index);

          // Wenn Profile Tab geöffnet wird, loadUserData ausführen
          if (index == 2) {
            _profileKey.currentState?.loadUserData();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Homepage",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Watchlist",
          ),
        ],
      ),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _selectedPageIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (_) => child);
        },
      ),
    );
  }
}
