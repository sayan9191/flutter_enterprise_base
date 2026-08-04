import 'package:base_structure/core/failure/failure.dart';
import 'package:base_structure/core/resources/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success.isSuccess returns true', () {
      const result = Success<int>(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('FailureResult.isFailure returns true', () {
      const result = FailureResult<int>(NetworkFailure());
      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
    });

    test('when maps success and failure branches', () {
      const success = Success<int>(10);
      const failure = FailureResult<int>(ServerFailure());

      expect(
        success.when(success: (d) => d * 2, orElse: (_) => -1),
        20,
      );
      expect(
        failure.when(success: (d) => d, orElse: (_) => -1),
        -1,
      );
    });

    test('map transforms success value', () {
      const result = Success<int>(5);
      final mapped = result.map((v) => v.toString());
      expect(mapped, isA<Success<String>>());
      expect((mapped as Success<String>).data, '5');
    });

    test('map preserves failure', () {
      const result = FailureResult<int>(CacheFailure());
      final mapped = result.map((v) => v.toString());
      expect(mapped, isA<FailureResult<String>>());
    });
  });
}
