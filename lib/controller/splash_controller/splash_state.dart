enum SplashNavigationState { loading, homeScreen,loginScreen }

class SplashState {
  final SplashNavigationState navigationScreen;

  const SplashState({this.navigationScreen = SplashNavigationState.loading});

  SplashState copyWith({SplashNavigationState? navigationScreen}) {
    return SplashState(
      navigationScreen: navigationScreen ?? this.navigationScreen,
    );
  }
}
