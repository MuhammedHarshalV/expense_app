class LoginState {
  final bool isSubmit;
  final bool isSee;

  const LoginState({this.isSubmit = false, this.isSee = false});

  LoginState copyWith({bool? isSubmit, bool? isSee}) {
    return LoginState(
      isSubmit: isSubmit ?? this.isSubmit,
      isSee: isSee ?? this.isSee,
    );
  }
}
