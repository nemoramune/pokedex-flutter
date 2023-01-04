import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Object error, StackTrace stackTrace) = Failure<T>;
}

extension KotlinLikeResult<T> on Result<T> {
  T? get getOrNull {
    final result = this;
    if (result is Success<T>) return result.value;
    return null;
  }

  Result<T> onSuccess(void Function(T value) action) {
    final value = getOrNull;
    if (value != null) action(value);
    return this;
  }

  Result<T> onFailure(void Function(Object error, StackTrace stackTrace) action) {
    final result = this;
    if (result is Failure<T>) action(result.error, result.stackTrace);
    return this;
  }
}

Result<T> runCatching<T>(T Function() block) {
  try {
    return Result.success(block());
  } catch (error, stackTrace) {
    return Result.failure(error, stackTrace);
  }
}

Future<Result<T>> awaitCatching<T, E extends Object>(
  Future<T> Function() block, {
  FutureOr<T> Function()? onError,
  bool Function(E error)? test,
}) async {
  try {
    return Result.success(await block());
  } catch (error, stackTrace) {
    if (onError == null) return Result.failure(error, stackTrace);
    if (test == null || error is E && test(error)) return Result.success(await onError());
    return Result.failure(error, stackTrace);
  }
}

extension FutureResult<T> on Future<T> {
  Future<Result<T>> toResult() => awaitCatching(() => this);
}

// future.onError バグっているかもしれない
// https://github.com/flutter/flutter/issues/114031
extension FutureResultToFuture<T> on Future<Result<T>> {
  Future<T?> thenNullable() => then((result) => result.getOrNull);
}
