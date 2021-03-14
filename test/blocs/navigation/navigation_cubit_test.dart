import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/models/models.dart';

void main() {
  group('NavigationCubit', () {
    test('initial state is MainScreenLoading', () {
      expect(NavigationCubit().state, const MainScreenLoading());
    });

    blocTest<NavigationCubit, NavigationState>(
      'emits NavScreenSelected state appropriately after selectedNavButton',
      build: () => NavigationCubit(),
      act: (cubit) => cubit.selectNavButton(0, true),
      expect: <NavigationState>[const NavScreenSelected(0, true)],
    );

    blocTest<NavigationCubit, NavigationState>(
      'emits NavScreenSelected state with false reclick on reclickToFalse',
      build: () => NavigationCubit(),
      act: (cubit) => cubit.reclickToFalse(2),
      expect: <NavigationState>[const NavScreenSelected(2, false)],
    );
  });
}
