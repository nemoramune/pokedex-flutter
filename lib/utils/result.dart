import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Object e, StackTrace stack) = Failure<T>;
}

Result<T> runCatching<T>(T Function() block) {
  try {
    return Result.success(block());
  } catch (e, stack) {
    return Result.failure(e, stack);
  }
}

Future<Result<T>> awaitCatching<T>(Future<T> Function() block) async {
  try {
    return Result.success(await block());
  } catch (e, stack) {
    return Result.failure(e, stack);
  }
}

extension FutureResult<T> on Future<T> {
  Future<Result<T>> toResult() => awaitCatching(() => this);
}
