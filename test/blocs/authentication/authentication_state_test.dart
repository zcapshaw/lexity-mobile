import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/models/models.dart';

void main() {
  User user;
  group('AuthenticationState', () {
    group('AuthenticationUnknown', () {
      test('supports value comparisons', () {
        expect(
          const AuthenticationUnknown(),
          const AuthenticationUnknown(),
        );
      });
    });

    group('Authenticated', () {
      test('supports value comparisons', () {
        expect(
          Authenticated(user),
          Authenticated(user),
        );
      });
    });

    group('Unauthenticated', () {
      test('supports value comparisons', () {
        expect(
          const Unauthenticated(),
          const Unauthenticated(),
        );
      });
    });

    group('AuthenticationLoading', () {
      test('supports value comparisons', () {
        expect(
          const AuthenticationLoading(),
          const AuthenticationLoading(),
        );
      });
    });

    group('AuthenticationFailed', () {
      test('supports value comparisons', () {
        expect(
          const AuthenticationFailed(),
          const AuthenticationFailed(),
        );
      });
    });
  });
}
