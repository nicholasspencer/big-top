import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_value.freezed.dart';

/// A sealed class representation of Flutter's `AsyncSnapshot` and `ConnectionState`.
///
/// This class represents the state of an asynchronous operation, such as a [Future]
/// or [Stream]. It can be in one of four states: [none], [waiting], [active], or [done].
/// Each state can optionally carry data of type [T] and/or an error.
/// The class provides convenience methods to transition between states,
/// check for the presence of data or errors, and retrieve data safely.
@Freezed(map: FreezedMapOptions.none, when: FreezedWhenOptions.none)
sealed class AsyncValue<T> with _$AsyncValue<T> {
  const AsyncValue._(); // for custom getters/methods

  /// No interaction yet, may carry data or error from a previous operation.
  const factory AsyncValue.none({
    T? data,
    Object? error,
    StackTrace? stackTrace,
  }) = AsyncValueNone<T>;

  /// Has not started yet, may carry data or error from a previous operation.
  const factory AsyncValue.waiting({
    T? data,
    Object? error,
    StackTrace? stackTrace,
  }) = AsyncValueWaiting<T>;

  /// Has started, may carry data or error.
  ///
  /// An active state indicates that an asynchronous operation is ongoing.
  /// It may carry partial or complete data, as well as an error if one has
  /// occurred during the operation. This is typically used with [Stream]s but
  /// may also indicate that a previously resolved [Future] is being
  /// refreshed.
  const factory AsyncValue.active({
    T? data,
    Object? error,
    StackTrace? stackTrace,
  }) = AsyncValueActive<T>;

  /// Completed, may carry data or error.
  const factory AsyncValue.done({
    T? data,
    Object? error,
    StackTrace? stackTrace,
  }) = AsyncValueDone<T>;

  /// Whether this value holds non-null data.
  bool get hasData => data != null;

  /// Whether this value holds a non-null error.
  bool get hasError => error != null;

  /// Returns latest data, throwing if absent.
  T requireData() {
    final data = this.data;
    final error = this.error;

    if (data != null) {
      return data;
    }

    if (error != null) {
      Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
    }

    throw StateError('AsyncValue has no data.');
  }

  /// Maps [data] to a new type [TT] while preserving the async state.
  ///
  /// Uses a type check (`data is T`) so that nullable type parameters such as
  /// `AsyncValue<Object?>` are handled correctly — null is a valid value of
  /// type `Object?` and will be passed to [mapper].
  ///
  /// If [data] does not satisfy the type check (e.g. it is null and [T] is
  /// non-nullable), [mapper] is not called and the result carries null data.
  ///
  /// [error] and [stackTrace] are always preserved unchanged.
  AsyncValue<TT> map<TT>(TT Function(T) mapper) {
    final mapped = data is T ? mapper(data as T) : null;
    return switch (this) {
      AsyncValueNone() => AsyncValue.none(data: mapped, error: error, stackTrace: stackTrace),
      AsyncValueWaiting() => AsyncValue.waiting(data: mapped, error: error, stackTrace: stackTrace),
      AsyncValueActive() => AsyncValue.active(data: mapped, error: error, stackTrace: stackTrace),
      AsyncValueDone() => AsyncValue.done(data: mapped, error: error, stackTrace: stackTrace),
    };
  }

  /// Convenience transitions.
  static const Object _useExisting = Object();

  AsyncValue<T> toNothing({
    Object? data = _useExisting,
    Object? error = _useExisting,
    Object? stackTrace = _useExisting,
  }) => AsyncValueNone<T>(
    data: identical(data, _useExisting) ? this.data : data as T?,
    error: identical(error, _useExisting) ? this.error : error,
    stackTrace: identical(stackTrace, _useExisting)
        ? this.stackTrace
        : stackTrace as StackTrace?,
  );

  AsyncValue<T> toWaiting({
    Object? data = _useExisting,
    Object? error = _useExisting,
    Object? stackTrace = _useExisting,
  }) => AsyncValueWaiting<T>(
    data: identical(data, _useExisting) ? this.data : data as T?,
    error: identical(error, _useExisting) ? this.error : error,
    stackTrace: identical(stackTrace, _useExisting)
        ? this.stackTrace
        : stackTrace as StackTrace?,
  );

  AsyncValue<T> toActive({
    Object? data = _useExisting,
    Object? error = _useExisting,
    Object? stackTrace = _useExisting,
  }) => AsyncValueActive<T>(
    data: identical(data, _useExisting) ? this.data : data as T?,
    error: identical(error, _useExisting) ? this.error : error,
    stackTrace: identical(stackTrace, _useExisting)
        ? this.stackTrace
        : stackTrace as StackTrace?,
  );

  AsyncValue<T> toDone({
    Object? data = _useExisting,
    Object? error = _useExisting,
    Object? stackTrace = _useExisting,
  }) => AsyncValueDone<T>(
    data: identical(data, _useExisting) ? this.data : data as T?,
    error: identical(error, _useExisting) ? this.error : error,
    stackTrace: identical(stackTrace, _useExisting)
        ? this.stackTrace
        : stackTrace as StackTrace?,
  );
}

/// Extension on [Stream] of [AsyncValue] that maps the inner data value while
/// preserving the async state of each emitted element.
extension AsyncValueStreamExtension<T> on Stream<AsyncValue<T>> {
  /// Maps the [AsyncValue.data] of each emitted value using [mapper], preserving
  /// the variant ([none], [waiting], [active], [done]) and any [error] /
  /// [stackTrace] on each element.
  ///
  /// Delegates to [AsyncValue.map] — see its documentation for null-handling
  /// semantics.
  Stream<AsyncValue<TT>> asyncValueMap<TT>(TT Function(T) mapper) =>
      map((asyncValue) => asyncValue.map(mapper));
}
