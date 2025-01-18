import 'package:equatable/equatable.dart';

mixin TrackAnalytic on Equatable {
  /// Name of this event
  String get eventName;

  /// Properties associated to this analytic log
  Map<String, Object> get properties => const <String, Object>{};

  @override
  List<Object> get props => [eventName, properties];
}
