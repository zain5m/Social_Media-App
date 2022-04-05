part of 'social_register_cubit.dart';

@immutable
abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterSccessState extends SocialRegisterStates {}

class SocialRegisterErrorState extends SocialRegisterStates {
  final String error;
  SocialRegisterErrorState(this.error);
}

class SocialCreateLoadingState extends SocialRegisterStates {}

class SocialCreateSccessState extends SocialRegisterStates {
  final String uId;
  SocialCreateSccessState(this.uId);
}

class SocialCreateErrorState extends SocialRegisterStates {}

class SocialRegisterchangePasswordVisibilityState extends SocialRegisterStates {
}
