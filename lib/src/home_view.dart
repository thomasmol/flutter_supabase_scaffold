import 'package:flutter/material.dart';
import 'utils/auth_state.dart';
import 'profile/profile_view.dart';
import 'feed/feed_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String routeName = '/';
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends AuthState<HomeView> {
  late int _selectedIndex = 0;
  late PageController _pageController;
  late String _title = 'Home';

  static const List<Widget> _widgetOptions = <Widget>[
    FeedView(),
    ProfileView()
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _title = FeedView.title;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _title = FeedView.title;
          break;
        case 1:
          _title = ProfileView.title;
          break;
      }
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: _widgetOptions,
        controller: _pageController,
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
