import 'package:meta/meta.dart';

@immutable
class ModifyAccountState {
  final bool isPasswordValid;
  final bool isEmailValid;
  final bool isUsernameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool failure_ERROR_WEAK_PASSWORD;
  final bool failure_ERROR_REQUIRES_RECENT_LOGIN;
  final bool failure_ERROR_EMAIL_ALREADY_IN_USE;
  final bool failure_ERROR_INVALID_CREDENTIAL;
  final bool failure_ERROR_USERNAME_ALREADY_IN_USE;

  bool get isFormValid => isPasswordValid || isEmailValid || isUsernameValid;

  ModifyAccountState({
    @required this.isPasswordValid,
    @required this.isEmailValid,
    @required this.isSubmitting,
    @required this.isUsernameValid,
    @required this.isSuccess,
    @required this.failure_ERROR_WEAK_PASSWORD,
    @required this.failure_ERROR_REQUIRES_RECENT_LOGIN,
    @required this.failure_ERROR_EMAIL_ALREADY_IN_USE,
    @required this.failure_ERROR_INVALID_CREDENTIAL,
    @required this.failure_ERROR_USERNAME_ALREADY_IN_USE,
  });

  factory ModifyAccountState.empty() {
    return ModifyAccountState(
      isPasswordValid: true,
      isEmailValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  factory ModifyAccountState.loading() {
    return ModifyAccountState(
      isPasswordValid: true,
      isEmailValid: true,
      isUsernameValid: true,
      isSubmitting: true,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  factory ModifyAccountState.failure_ERROR_WEAK_PASSWORD() {
    return ModifyAccountState(
      isPasswordValid: true,
      isEmailValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: true,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  factory ModifyAccountState.failure_ERROR_REQUIRES_RECENT_LOGIN() {
    return ModifyAccountState(
      isPasswordValid: true,
      isEmailValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: true,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  factory ModifyAccountState.failure_ERROR_EMAIL_ALREADY_IN_USE() {
    return ModifyAccountState(
      isPasswordValid: true,
      isEmailValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: true,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  factory ModifyAccountState.failure_ERROR_INVALID_CREDENTIAL() {
    return ModifyAccountState(
      isPasswordValid: true,
      isEmailValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: true,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  factory ModifyAccountState.failure_ERROR_USERNAME_ALREADY_IN_USE() {
    return ModifyAccountState(
      isPasswordValid: true,
      isEmailValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: true,
    );
  }

  factory ModifyAccountState.success() {
    return ModifyAccountState(
      isPasswordValid: true,
      isEmailValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: true,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  ModifyAccountState updatePassword({
    bool isPasswordValid,
  }) {
    return copyWith(
      isPasswordValid: isPasswordValid,
      isEmailValid: false,
      isUsernameValid: false,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  ModifyAccountState updateEmail({
    bool isEmailValid,
  }) {
    return copyWith(
      isPasswordValid: false,
      isEmailValid: isEmailValid,
      isUsernameValid: false,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }
  ModifyAccountState updateUsername({
    bool isUsernameValid,
  }) {
    return copyWith(
      isPasswordValid: false,
      isEmailValid: false,
      isUsernameValid: isUsernameValid,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_REQUIRES_RECENT_LOGIN: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
      failure_ERROR_INVALID_CREDENTIAL: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
    );
  }

  ModifyAccountState copyWith({
    bool isPasswordValid,
    bool isEmailValid,
    bool isUsernameValid,
    bool isSubmitting,
    bool isSuccess,
    bool failure_ERROR_WEAK_PASSWORD,
    bool failure_ERROR_REQUIRES_RECENT_LOGIN,
    bool failure_ERROR_EMAIL_ALREADY_IN_USE,
    bool failure_ERROR_INVALID_CREDENTIAL,
    bool failure_ERROR_USERNAME_ALREADY_IN_USE,
  }) {
    return ModifyAccountState(
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      failure_ERROR_WEAK_PASSWORD: failure_ERROR_WEAK_PASSWORD ?? this.failure_ERROR_WEAK_PASSWORD,
      failure_ERROR_REQUIRES_RECENT_LOGIN: failure_ERROR_REQUIRES_RECENT_LOGIN ?? this.failure_ERROR_REQUIRES_RECENT_LOGIN,
      failure_ERROR_EMAIL_ALREADY_IN_USE: failure_ERROR_EMAIL_ALREADY_IN_USE ?? this.failure_ERROR_EMAIL_ALREADY_IN_USE,
      failure_ERROR_INVALID_CREDENTIAL: failure_ERROR_INVALID_CREDENTIAL ?? this.failure_ERROR_INVALID_CREDENTIAL,
      failure_ERROR_USERNAME_ALREADY_IN_USE: failure_ERROR_USERNAME_ALREADY_IN_USE ?? this.failure_ERROR_USERNAME_ALREADY_IN_USE,
    );
  }

  @override
  String toString() {
    return '''ModifyAccountState {
      isPasswordValid: $isPasswordValid,    
      isEmailValid: $isEmailValid,  
      isUsernameValid: $isUsernameValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      failure_ERROR_WEAK_PASSWORD: $failure_ERROR_WEAK_PASSWORD,
      failure_ERROR_REQUIRES_RECENT_LOGIN : $failure_ERROR_REQUIRES_RECENT_LOGIN,
      failure_ERROR_EMAIL_ALREADY_IN_USE: $failure_ERROR_INVALID_CREDENTIAL,
      failure_ERROR_INVALID_CREDENTIAL: $failure_ERROR_INVALID_CREDENTIAL,
      failure_ERROR_USERNAME_ALREADY_IN_USE: $failure_ERROR_USERNAME_ALREADY_IN_USE,
    }''';
  }
}
