class ScrollState {
  final bool isScrolling;
  ScrollState({this.isScrolling = false});
  ScrollState copyWith({bool? isScrolling}) {
    return ScrollState(isScrolling: isScrolling ?? this.isScrolling);
  }
}
