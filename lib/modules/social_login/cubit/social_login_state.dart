part of 'social_login_cubit.dart';

@immutable
abstract class SocialLoginState {}

class SocialLoginInitialState extends SocialLoginState {}

class SocialLoginLoadingState extends SocialLoginState {}

class SocialLoginSccessState extends SocialLoginState {
  final String uId;
  SocialLoginSccessState(this.uId);
}

class SocialLoginErrorState extends SocialLoginState {
  final String error;

  SocialLoginErrorState(this.error);
}

class SocialChangePasswordVisibilityState extends SocialLoginState {}
