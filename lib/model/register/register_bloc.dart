import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/register/register.dart';
import 'package:freetitle/model/validators.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  final reference = FirebaseDatabase.instance.reference().child('users');

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transform(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged &&
          event is! UsernameChanged &&
          event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged ||
          event is UsernameChanged ||
          event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
          event.email, event.username, event.password);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapUsernameChangedToState(String username) async* {
    yield currentState.update(
      isUsernameValid: Validators.isValidUsername(username),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String username,
    String password,
  ) async* {
    yield RegisterState.loading();
    bool isUsernameUsed = false;
    await reference.child(username).once().then((DataSnapshot onValue) {
      if (onValue.value == null) {
        isUsernameUsed = false;
      } else {
        isUsernameUsed = true;
      }
    });
    try {
      if (isUsernameUsed) {
        yield RegisterState.failure_ERROR_USERNAME_ALREADY_IN_USE();
      } else{
        await _userRepository.signUp(
          email: email,
          password: password,
        );
        await reference.child(username).set({
          'username': username,
          'password': password,
          'email': email,
        });
        yield RegisterState.success();
      }


    } catch (e) {
      switch (e.code) {
        case "ERROR_WEAK_PASSWORD":
          yield RegisterState.failure_ERROR_WEAK_PASSWORD();
          break;
        case "ERROR_INVALID_EMAIL":
          yield RegisterState.failure_ERROR_INVALID_EMAIL();
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          yield RegisterState.failure_ERROR_EMAIL_ALREADY_IN_USE();
          break;
      }
    }
  }
}
