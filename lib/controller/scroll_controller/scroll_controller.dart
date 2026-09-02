import 'package:flutter_riverpod/legacy.dart';

import 'scroll_state.dart';

class ScrollControllerNotifier extends StateNotifier<ScrollState> {
  ScrollControllerNotifier() : super(ScrollState());

  void updateState({bool? scrollValue}) {
    state = state.copyWith(isScrolling: scrollValue);
  }
}

final scrollProvider =
    StateNotifierProvider<ScrollControllerNotifier, ScrollState>(
      (ref) => ScrollControllerNotifier(),
    );
