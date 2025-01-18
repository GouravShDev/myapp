import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/services/analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsRouteObserver extends AutoRouterObserver {
  final AnalyticsService _analytics = AnalyticsService();

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      _analytics.logScreenView(
        screenName: route.settings.name!,
        screenClass: route.settings.arguments?.toString(),
      );
      
      _analytics.logCustomEvent(
        name: 'screen_navigation',
        parameters: {
          'from_screen': previousRoute?.settings.name ?? 'none',
          'to_screen': route.settings.name ?? '',
          'navigation_type': 'push',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
    super.didPush(route, previousRoute);
  }

  @override 
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name != null && previousRoute?.settings.name != null) {
      _analytics.logCustomEvent(
        name: 'screen_navigation',
        parameters: {
          'from_screen': route.settings.name ?? '',
          'to_screen': previousRoute?.settings.name ?? '',
          'navigation_type': 'pop',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _analytics.logCustomEvent(
      name: 'tab_navigation',
      parameters: {
        'tab_name': route.name,
        'previous_tab': previousRoute?.name ?? 'none',
        'action': 'init',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _analytics.logCustomEvent(
      name: 'tab_navigation',
      parameters: {
        'tab_name': route.name,
        'previous_tab': previousRoute.name,
        'action': 'change',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    _analytics.logScreenView(
      screenName: route.name,
      screenClass: 'TabView',
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute?.settings.name != null) {
      _analytics.logCustomEvent(
        name: 'screen_navigation',
        parameters: {
          'from_screen': oldRoute?.settings.name ?? 'none',
          'to_screen': newRoute?.settings.name ?? '',
          'navigation_type': 'replace',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      _analytics.logCustomEvent(
        name: 'screen_navigation',
        parameters: {
          'removed_screen': route.settings.name ?? '',
          'navigation_type': 'remove',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
    super.didRemove(route, previousRoute);
  }
}