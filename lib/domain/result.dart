import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory ok(T value) = Ok;
  const factory failure(String message) = Failure;
}
