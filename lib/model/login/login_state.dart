import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isGoogleFailure;
  final bool Failure_ERROR_INVALID_EMAIL;
  final bool Failure_ERROR_WRONG_PASSWORD;
  final bool Failure_ERROR_USER_NOT_FOUND;
  final bool Failure_ERROR_USER_DISABLED;
  final bool Failure_ERROR_TOO_MANY_REQUESTS;
  final bool Failure_ERROR_OPERATION_NOT_ALLOWED;


  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isGoogleFailure,
    @required this.Failure_ERROR_INVALID_EMAIL,
    @required this.Failure_ERROR_WRONG_PASSWORD,
    @required this.Failure_ERROR_USER_NOT_FOUND,
    @required this.Failure_ERROR_USER_DISABLED,
    @required this.Failure_ERROR_TOO_MANY_REQUESTS,
    @required this.Failure_ERROR_OPERATION_NOT_ALLOWED,
  });

  factory LoginState.empty() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,

    );
  }

  factory LoginState.loading() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }
  factory LoginState.failure_Google() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: true,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }

  factory LoginState.failure_ERROR_INVALID_EMAIL() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: true,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }
  factory LoginState.failure_ERROR_WRONG_PASSWORD() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: true,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }
  factory LoginState.failure_ERROR_USER_NOT_FOUND() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: true,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }
  factory LoginState.failure_ERROR_USER_DISABLED() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: true,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }
  factory LoginState.failure_ERROR_TOO_MANY_REQUESTS() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: true,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }
  factory LoginState.failure_ERROR_OPERATION_NOT_ALLOWED() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: true,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }

  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isGoogleFailure: false,
      Failure_ERROR_INVALID_EMAIL: false,
      Failure_ERROR_WRONG_PASSWORD: false,
      Failure_ERROR_USER_NOT_FOUND: false,
      Failure_ERROR_USER_DISABLED: false,
      Failure_ERROR_TOO_MANY_REQUESTS: false,
      Failure_ERROR_OPERATION_NOT_ALLOWED: false,
    );
  }

  LoginState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    isGoogleFailure: false,
    Failure_ERROR_INVALID_EMAIL: false,
    Failure_ERROR_WRONG_PASSWORD: false,
    Failure_ERROR_USER_NOT_FOUND: false,
    Failure_ERROR_USER_DISABLED: false,
    Failure_ERROR_TOO_MANY_REQUESTS: false,
    Failure_ERROR_OPERATION_NOT_ALLOWED: false,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isGoogleFailure: isGoogleFailure ?? this.isGoogleFailure,
      Failure_ERROR_INVALID_EMAIL: Failure_ERROR_INVALID_EMAIL ?? this.Failure_ERROR_INVALID_EMAIL,
      Failure_ERROR_WRONG_PASSWORD: Failure_ERROR_WRONG_PASSWORD ?? this.Failure_ERROR_WRONG_PASSWORD,
      Failure_ERROR_USER_NOT_FOUND: Failure_ERROR_USER_NOT_FOUND ?? this.Failure_ERROR_USER_NOT_FOUND,
      Failure_ERROR_USER_DISABLED: Failure_ERROR_USER_DISABLED ?? this.Failure_ERROR_USER_DISABLED,
      Failure_ERROR_TOO_MANY_REQUESTS: Failure_ERROR_TOO_MANY_REQUESTS ?? this.Failure_ERROR_TOO_MANY_REQUESTS,
      Failure_ERROR_OPERATION_NOT_ALLOWED: Failure_ERROR_OPERATION_NOT_ALLOWED ?? this.Failure_ERROR_OPERATION_NOT_ALLOWED,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isGoogleFailure: $isGoogleFailure,
      Failure_ERROR_INVALID_EMAIL: $Failure_ERROR_INVALID_EMAIL,
      Failure_ERROR_WRONG_PASSWORD: $Failure_ERROR_WRONG_PASSWORD,
      Failure_ERROR_USER_NOT_FOUND: $Failure_ERROR_USER_NOT_FOUND,
      Failure_ERROR_USER_DISABLED: $Failure_ERROR_USER_DISABLED,
      Failure_ERROR_TOO_MANY_REQUESTS: $Failure_ERROR_TOO_MANY_REQUESTS,
      Failure_ERROR_OPERATION_NOT_ALLOWED: $Failure_ERROR_OPERATION_NOT_ALLOWED,
    }''';
  }
}
