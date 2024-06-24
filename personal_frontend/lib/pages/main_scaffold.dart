import 'package:flutter/material.dart';
import 'package:personal_frontend/pages/base_layout.dart';
import 'package:personal_frontend/pages/following_feed.dart';
import 'package:personal_frontend/pages/profiles/current_user_profile.dart';
import 'package:personal_frontend/stock_pages/search_stocks.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    // GlobalKey<NavigatorState>(),
    // GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            final isFirstRouteInCurrentTab = !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
            if (isFirstRouteInCurrentTab) {
              if (_selectedIndex != 0) {
                setState(() {
                  _selectedIndex = 0;
                });
                return false;
              }
              return true;
            } else {
              return false;
            }
          },
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              Navigator(
                key: _navigatorKeys[0],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => const FollowingFeed());
                },
              ),
              Navigator(
                key: _navigatorKeys[1],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => const SearchStocks());
                },
              ),
              // Navigator(
              //   key: _navigatorKeys[2],
              //   onGenerateRoute: (routeSettings) {
              //     return MaterialPageRoute(builder: (context) => const SearchUsers());
              //   },
              // ),
              // Navigator(
              //   key: _navigatorKeys[3],
              //   onGenerateRoute: (routeSettings) {
              //     return MaterialPageRoute(builder: (context) => const AddPost());
              //   },
              // ),
              Navigator(
                key: _navigatorKeys[2],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => const CurrentUserProfile());
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (_selectedIndex == index) {
              final navigatorState = _navigatorKeys[index].currentState;
              navigatorState!.popUntil((route) {
                // print("Route isFirst: ${route.isFirst} for index $index");
                return route.isFirst;
              });
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.stacked_line_chart_sharp,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: '',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.search_sharp,
            //     color: Theme.of(context).colorScheme.secondary,
            //   ),
            //   label: '',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.add,
            //     color: Theme.of(context).colorScheme.secondary,
            //   ),
            //   label: '',
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
