import 'package:flutter/material.dart';
import 'package:personal_frontend/pages/add_post.dart';
import 'package:personal_frontend/pages/base_layout.dart';
import 'package:personal_frontend/pages/following_feed.dart';
import 'package:personal_frontend/pages/profiles/current_user_profile.dart';
import 'package:personal_frontend/pages/search_stocks.dart';
import 'package:personal_frontend/pages/search_users.dart';

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
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
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
              Navigator(
                key: _navigatorKeys[2],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => const SearchUsers());
                },
              ),
              Navigator(
                key: _navigatorKeys[3],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (context) => const AddPost());
                },
              ),
              Navigator(
                key: _navigatorKeys[4],
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
                print("Route isFirst: ${route.isFirst} for index $index");
                return route.isFirst;
              });
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }

            // // if statement handles the case that the navigation icon from the sub page of the main page is selected
            // if (_selectedIndex == index) {
            //   _navigatorKeys[index].currentState!.popUntil((route) => route.isCurrent);
            // } else {
            //   // otherwise, the user is on a different tab than the icon selected in the bottom navigation bar
            //   setState(() {
            //     _selectedIndex = index;
            //   });
            // }

            // setState(() {
            //     _selectedIndex = index;
            //   });

          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
