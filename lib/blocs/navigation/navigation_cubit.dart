import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const MainScreenLoading());

  void selectNavButton(int index, bool reclick) {
    emit(NavScreenSelected(index, reclick));
  }

  // Used to allow for reclick scroll up when the screen index does NOT change
  void reclickToFalse(int index) {
    emit(NavScreenSelected(index, false));
  }
}
