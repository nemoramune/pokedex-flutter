import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Object e) = Failure<T>;
}

Result<R> runCatching<R>(R Function() block) {
  try {
    return Result.success(block());
  } catch (e) {
    return Result.failure(e);
  }
}
