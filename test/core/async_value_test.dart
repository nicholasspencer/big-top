import 'dart:async';

import 'package:big_top/src/core/async_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncValue', () {
    group('states', () {
      test('none has no data and no error', () {
        const value = AsyncValue<int>.none();
        expect(value, isA<AsyncValueNone<int>>());
        expect(value.data, isNull);
        expect(value.error, isNull);
        expect(value.hasData, isFalse);
        expect(value.hasError, isFalse);
      });

      test('waiting has no data and no error', () {
        const value = AsyncValue<int>.waiting();
        expect(value, isA<AsyncValueWaiting<int>>());
        expect(value.hasData, isFalse);
        expect(value.hasError, isFalse);
      });

      test('active can carry data', () {
        const value = AsyncValue<int>.active(data: 42);
        expect(value, isA<AsyncValueActive<int>>());
        expect(value.data, 42);
        expect(value.hasData, isTrue);
      });

      test('done can carry data', () {
        const value = AsyncValue<int>.done(data: 42);
        expect(value, isA<AsyncValueDone<int>>());
        expect(value.data, 42);
        expect(value.hasData, isTrue);
        expect(value.hasError, isFalse);
      });

      test('done can carry error', () {
        final value = AsyncValue<int>.done(
          error: Exception('fail'),
          stackTrace: StackTrace.current,
        );
        expect(value, isA<AsyncValueDone<int>>());
        expect(value.hasError, isTrue);
        expect(value.hasData, isFalse);
      });

      test('done can carry both data and error', () {
        final value = AsyncValue<int>.done(
          data: 42,
          error: Exception('fail'),
        );
        expect(value.hasData, isTrue);
        expect(value.hasError, isTrue);
        expect(value.data, 42);
      });
    });

    group('requireData', () {
      test('returns data when present', () {
        const value = AsyncValue<int>.done(data: 42);
        expect(value.requireData(), 42);
      });

      test('throws error when has error but no data', () {
        final value = AsyncValue<int>.done(error: Exception('fail'));
        expect(() => value.requireData(), throwsA(isA<Exception>()));
      });

      test('throws StateError when no data and no error', () {
        const value = AsyncValue<int>.none();
        expect(() => value.requireData(), throwsA(isA<StateError>()));
      });

      test('returns data even when error is also present', () {
        final value = AsyncValue<int>.done(
          data: 42,
          error: Exception('fail'),
        );
        expect(value.requireData(), 42);
      });
    });

    group('map', () {
      test('transforms data and preserves state variant (done)', () {
        const value = AsyncValue<int>.done(data: 10);
        final mapped = value.map((n) => n * 2);
        expect(mapped, isA<AsyncValueDone<int>>());
        expect(mapped.data, 20);
      });

      test('transforms data and preserves state variant (active)', () {
        const value = AsyncValue<int>.active(data: 5);
        final mapped = value.map((n) => 'value: $n');
        expect(mapped, isA<AsyncValueActive<String>>());
        expect(mapped.data, 'value: 5');
      });

      test('transforms data and preserves state variant (waiting)', () {
        const value = AsyncValue<int>.waiting(data: 3);
        final mapped = value.map((n) => n.toDouble());
        expect(mapped, isA<AsyncValueWaiting<double>>());
        expect(mapped.data, 3.0);
      });

      test('transforms data and preserves state variant (none)', () {
        const value = AsyncValue<int>.none(data: 7);
        final mapped = value.map((n) => n > 5);
        expect(mapped, isA<AsyncValueNone<bool>>());
        expect(mapped.data, isTrue);
      });

      test('preserves error and stackTrace', () {
        final st = StackTrace.current;
        final value =
            AsyncValue<int>.done(data: 10, error: 'oops', stackTrace: st);
        final mapped = value.map((n) => n * 2);
        expect(mapped.data, 20);
        expect(mapped.error, 'oops');
        expect(mapped.stackTrace, st);
      });

      test('null data in non-nullable type results in null mapped data', () {
        const value = AsyncValue<int>.none();
        final mapped = value.map((n) => n * 2);
        expect(mapped.data, isNull);
      });

      test('works with nullable type parameter', () {
        const value = AsyncValue<Object?>.done(data: null);
        final mapped = value.map((v) => v.toString());
        expect(mapped.data, 'null');
      });
    });

    group('to* transitions', () {
      test('toWaiting carries forward data', () {
        const value = AsyncValue<int>.done(data: 42);
        final waiting = value.toWaiting();
        expect(waiting, isA<AsyncValueWaiting<int>>());
        expect(waiting.data, 42);
      });

      test('toActive carries forward data', () {
        const value = AsyncValue<int>.done(data: 42);
        final active = value.toActive();
        expect(active, isA<AsyncValueActive<int>>());
        expect(active.data, 42);
      });

      test('toDone carries forward data', () {
        const value = AsyncValue<int>.active(data: 42);
        final done = value.toDone();
        expect(done, isA<AsyncValueDone<int>>());
        expect(done.data, 42);
      });

      test('toNothing carries forward data', () {
        const value = AsyncValue<int>.done(data: 42);
        final none = value.toNothing();
        expect(none, isA<AsyncValueNone<int>>());
        expect(none.data, 42);
      });

      test('to* transitions can override data', () {
        const value = AsyncValue<int>.done(data: 42);
        final waiting = value.toWaiting(data: 99);
        expect(waiting.data, 99);
      });

      test('to* transitions can clear data with null', () {
        const value = AsyncValue<int>.done(data: 42);
        final waiting = value.toWaiting(data: null);
        expect(waiting.data, isNull);
      });

      test('to* carries forward error by default', () {
        final value =
            AsyncValue<int>.done(data: 42, error: 'oops');
        final active = value.toActive();
        expect(active.error, 'oops');
        expect(active.data, 42);
      });
    });

    group('hasData / hasError', () {
      test('hasData is true when data is non-null', () {
        const value = AsyncValue<int>.done(data: 0);
        expect(value.hasData, isTrue);
      });

      test('hasData is false when data is null', () {
        const value = AsyncValue<int>.none();
        expect(value.hasData, isFalse);
      });

      test('hasError is true when error is non-null', () {
        final value = AsyncValue<int>.done(error: Exception('e'));
        expect(value.hasError, isTrue);
      });

      test('hasError is false when error is null', () {
        const value = AsyncValue<int>.done(data: 42);
        expect(value.hasError, isFalse);
      });
    });

    group('asyncValueMap stream extension', () {
      test('maps data in each emitted AsyncValue', () async {
        final controller = StreamController<AsyncValue<int>>();
        final mapped =
            controller.stream.asyncValueMap((n) => n * 10).toList();

        controller.add(const AsyncValue.none());
        controller.add(const AsyncValue.waiting(data: 1));
        controller.add(const AsyncValue.active(data: 2));
        controller.add(const AsyncValue.done(data: 3));
        await controller.close();

        final results = await mapped;
        expect(results, hasLength(4));
        expect(results[0].data, isNull); // none with no data
        expect(results[1].data, 10);
        expect(results[2].data, 20);
        expect(results[3].data, 30);
      });
    });
  });
}
