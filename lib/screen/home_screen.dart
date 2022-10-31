import 'package:flutter/material.dart';
import 'package:graphql_instagram/screen/profile_screen.dart';
import 'package:graphql_instagram/screen/reels_screen.dart';
import 'package:graphql_instagram/screen/search_screen.dart';
import 'package:graphql_instagram/screen/shop_screen.dart';
import 'package:graphql_instagram/store/user_provider.dart';
import 'package:provider/provider.dart';

import 'feed_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    SearchScreen(),
    ReelsScreen(),
    ShopScreen(),
    ProfileScreen(
      userId: '1',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    return Scaffold(
      body: isLoggedIn
          ? _widgetOptions.elementAt(_selectedIndex)
          : const LoginScreen(),
      bottomNavigationBar: isLoggedIn
          ? BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              onTap: _onItemTapped,
              currentIndex: _selectedIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'serach',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie),
                  label: 'reels',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  label: 'shop',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'profile',
                ),
              ],
            )
          : null,
    );
  }

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
