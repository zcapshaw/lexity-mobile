part of 'navigation_cubit.dart';

@immutable
abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];

  // starting screen index is 0
  int get index => 0;
}

// The default state, if no book is selected
class MainScreenLoading extends NavigationState {
  const MainScreenLoading();
}

class NavScreenSelected extends NavigationState {
  const NavScreenSelected(this.index, this.reclick);
  @override // overrides the getter in NavigationState
  final int index;
  final bool reclick;

  @override
  List<Object> get props => [index, reclick];
}
