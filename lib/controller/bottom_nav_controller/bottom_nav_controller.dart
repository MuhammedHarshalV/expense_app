import 'package:expense/controller/bottom_nav_controller/bottom_state.dart';

import 'package:flutter_riverpod/legacy.dart';

class BottomNavController extends StateNotifier<BottomNavState> {
  BottomNavController() : super(const BottomNavState());

  void changeIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

final bottomNavProvider =
    StateNotifierProvider<BottomNavController, BottomNavState>(
      (ref) => BottomNavController(),
    );
