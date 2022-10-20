import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigationKey =
      new GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String _route) {
    navigationKey.currentState?.popAndPushNamed(_route);
  }

  void navigateToRoute(String _route) {
    navigationKey.currentState?.pushNamed(_route);
  }

  void navigateToPage(Widget _page) {
    navigationKey.currentState?.push(
      MaterialPageRoute(
        builder: (BuildContext _context) {
          return _page;
        },
      ),
    );
  }

  void goBack() {
    navigationKey.currentState?.pop();
  }
}
