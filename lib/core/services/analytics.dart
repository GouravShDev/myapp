import 'package:codersgym/core/utils/track_analytic_mixin.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  late final FirebaseAnalytics _analytics;

  // Singleton pattern
  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal() {
    _analytics = FirebaseAnalytics.instance;
  }

  // Screen tracking
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // User properties
  Future<void> setUserProperties({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // Custom events
  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Predefined events
  Future<void> logPurchase({
    required double value,
    required String currency,
    List<AnalyticsEventItem>? items,
  }) async {
    await _analytics.logPurchase(
      value: value,
      currency: currency,
      items: items,
    );
  }

  // analytic state
  Future<void> logAnalyticEvent(TrackAnalytic analytic) async {
    return _analytics.logEvent(
      name: analytic.eventName,
      parameters: analytic.properties,
    );
  }

  Future<void> logLogin({
    required String method,
  }) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp({
    required String method,
  }) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logSearch({
    required String searchTerm,
  }) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  // Error tracking
  Future<void> logError({
    required String error,
    StackTrace? stackTrace,
  }) async {
    await _analytics.logEvent(
      name: 'errorReported',
      parameters: {
        'error_message': error,
        'stack_trace': stackTrace ?? "No available",
      },
    );
  }

  // Enable/disable analytics collection
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  // Reset analytics data
  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
  }
}
