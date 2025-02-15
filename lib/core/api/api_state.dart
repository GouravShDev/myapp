import 'package:equatable/equatable.dart';

sealed class ApiState<S, E extends Exception> extends Equatable {
  const ApiState();
  // Factory constructor to initialize ApiState with ApiInitial
  factory ApiState.initial() => ApiInitial<S, E>();

  bool get isInitial => this is ApiInitial;
  bool get isLoading => this is ApiLoading;
  bool get isLoaded => this is ApiLoaded;
  bool get isError => this is ApiError;

  T when<T>({
    required T Function() onInitial,
    required T Function(S? cachedData) onLoading,
    required T Function(S value) onLoaded,
    required T Function(E exception) onError,
  }) {
    return switch (this) {
      ApiInitial() => onInitial(),
      ApiLoading<S, E> loading => onLoading(loading.cachedData),
      ApiLoaded<S, E> loaded => onLoaded(loaded.data),
      ApiError<S, E> error => onError(error.error),
    };
  }
    T mayBeWhen<T>({
    T Function()? onInitial,
    T Function(S? cachedData)? onLoading,
    T Function(S value)? onLoaded,
    T Function(E exception)? onError,
    required T Function() orElse,
  }) {
    return switch (this) {
      ApiInitial() when onInitial != null => onInitial(),
      ApiLoading<S, E> loading when onLoading != null => onLoading(loading.cachedData),
      ApiLoaded<S, E> loaded when onLoaded != null => onLoaded(loaded.data),
      ApiError<S, E> error when onError != null => onError(error.error),
      _ => orElse(),
    };
  }
}

class ApiInitial<S, E extends Exception> extends ApiState<S, E> {
  @override
  List<Object?> get props => [];
}

class ApiLoading<S, E extends Exception> extends ApiState<S, E> {
  final S? cachedData;
  const ApiLoading({this.cachedData});
  @override
  List<Object?> get props => [cachedData];
}

class ApiLoaded<S, E extends Exception> extends ApiState<S, E> {
  final S data;
  const ApiLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ApiError<S, E extends Exception> extends ApiState<S, E> {
  final E error;
  const ApiError(this.error);

  @override
  List<Object?> get props => [error];
}
