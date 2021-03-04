import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/blocs/blocs.dart';

void main() {
  Uri uri;
  group('AuthenticationEvent', () {
    group('AppStarted', () {
      test('supports value comparisons', () {
        expect(
          const AppStarted(),
          const AppStarted(),
        );
      });
    });

    group('LogInWithService', () {
      test('supports value comparisons', () {
        expect(
          const LogInWithService('twitter'),
          const LogInWithService('twitter'),
        );
      });
    });

    group('LoggedIn', () {
      test('supports value comparisons', () {
        expect(
          const LoggedIn(),
          const LoggedIn(),
        );
      });
    });

    group('LoggedOut', () {
      test('supports value comparisons', () {
        expect(
          const LoggedOut(),
          const LoggedOut(),
        );
      });
    });

    group('InboundUriLinkReceived', () {
      test('supports value comparisons', () {
        expect(
          InboundUriLinkReceived(uri),
          InboundUriLinkReceived(uri),
        );
      });
    });
  });
}
