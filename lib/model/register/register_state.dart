import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isEmailValid;
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool failure_ERROR_USERNAME_ALREADY_IN_USE;
  final bool failure_ERROR_WEAK_PASSWORD;
  final bool failure_ERROR_INVALID_EMAIL;
  final bool failure_ERROR_EMAIL_ALREADY_IN_USE;

//  final bool isFailure;

  bool get isFormValid => isEmailValid && isUsernameValid && isPasswordValid;

  RegisterState({
    @required this.isEmailValid,
    @required this.isUsernameValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.failure_ERROR_USERNAME_ALREADY_IN_USE,
    @required this.failure_ERROR_WEAK_PASSWORD,
    @required this.failure_ERROR_INVALID_EMAIL,
    @required this.failure_ERROR_EMAIL_ALREADY_IN_USE,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isUsernameValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_INVALID_EMAIL: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isUsernameValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_INVALID_EMAIL: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
    );
  }

  factory RegisterState.failure_ERROR_USERNAME_ALREADY_IN_USE() {
    return RegisterState(
      isEmailValid: true,
      isUsernameValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: true,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_INVALID_EMAIL: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
    );
  }

  factory RegisterState.failure_ERROR_WEAK_PASSWORD() {
    return RegisterState(
      isEmailValid: true,
      isUsernameValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
      failure_ERROR_WEAK_PASSWORD: true,
      failure_ERROR_INVALID_EMAIL: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
    );
  }

  factory RegisterState.failure_ERROR_INVALID_EMAIL() {
    return RegisterState(
      isEmailValid: true,
      isUsernameValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_INVALID_EMAIL: true,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
    );
  }

  factory RegisterState.failure_ERROR_EMAIL_ALREADY_IN_USE() {
    return RegisterState(
      isEmailValid: true,
      isUsernameValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_INVALID_EMAIL: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isUsernameValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_INVALID_EMAIL: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
    );
  }

  RegisterState update({
    bool isEmailValid,
    bool isUsernameValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isUsernameValid: isUsernameValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      failure_ERROR_USERNAME_ALREADY_IN_USE: false,
      failure_ERROR_WEAK_PASSWORD: false,
      failure_ERROR_INVALID_EMAIL: false,
      failure_ERROR_EMAIL_ALREADY_IN_USE: false,
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isUsernameValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    failure_ERROR_USERNAME_ALREADY_IN_USE,
    failure_ERROR_WEAK_PASSWORD,
    failure_ERROR_INVALID_EMAIL,
    failure_ERROR_EMAIL_ALREADY_IN_USE,
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      failure_ERROR_USERNAME_ALREADY_IN_USE: failure_ERROR_USERNAME_ALREADY_IN_USE ?? this.failure_ERROR_USERNAME_ALREADY_IN_USE,
      failure_ERROR_WEAK_PASSWORD: failure_ERROR_WEAK_PASSWORD ?? this.failure_ERROR_WEAK_PASSWORD,
      failure_ERROR_INVALID_EMAIL: failure_ERROR_INVALID_EMAIL ?? this.failure_ERROR_INVALID_EMAIL,
      failure_ERROR_EMAIL_ALREADY_IN_USE: failure_ERROR_EMAIL_ALREADY_IN_USE ?? this.failure_ERROR_EMAIL_ALREADY_IN_USE,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isEmailValid: $isEmailValid,
      isUsernameValid: $isUsernameValid,
      isPasswordValid: $isPasswordValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      failure_ERROR_USERNAME_ALREADY_IN_USE: $failure_ERROR_USERNAME_ALREADY_IN_USE,
      failure_ERROR_WEAK_PASSWORD: $failure_ERROR_WEAK_PASSWORD,
      failure_ERROR_INVALID_EMAIL: $failure_ERROR_INVALID_EMAIL,
      failure_ERROR_EMAIL_ALREADY_IN_USE: $failure_ERROR_EMAIL_ALREADY_IN_USE,
    }''';
  }
}
