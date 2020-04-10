import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/model/modify_acount/modify_acount_event.dart';
import 'package:freetitle/model/modify_acount/modify_acount_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/validators.dart';

class ModifyAccountBloc extends Bloc<ModifyAccountEvent, ModifyAccountState> {
  UserRepository _userRepository;
  final reference = Firestore.instance.collection('users');

  ModifyAccountBloc({@required UserRepository userRepository})
      : assert(userRepository != null ),
        _userRepository = userRepository;

  @override
  ModifyAccountState get initialState => ModifyAccountState.empty();

  @override
  Stream<ModifyAccountState> transform (
      Stream<ModifyAccountEvent> events,
      Stream<ModifyAccountState> Function(ModifyAccountEvent event) next
  ) {
    final observableStream = events as Observable<ModifyAccountEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! PasswordChanged && event is! EmailChanged && event is! UsernameChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is PasswordChanged || event is EmailChanged || event is UsernameChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<ModifyAccountState> mapEventToState(
      ModifyAccountEvent event,
  ) async* {
    if (event is PasswordChanged){
      yield* _mapPasswordChangedToState(event.password);
    }
    else if (event is EmailChanged){
      yield* _mapEmailChangedToState(event.email);
    }
    else if (event is UsernameChanged){
      yield* _mapUsernameChangedToState(event.username);
    }
    else if (event is Submitted){
      yield* _mapFormSubmittedToState(event.password, event.email, event.username);
    }
  }

  Stream<ModifyAccountState> _mapPasswordChangedToState(String password) async* {
    yield currentState.updatePassword(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<ModifyAccountState> _mapEmailChangedToState(String email) async* {
    yield currentState.updateEmail(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<ModifyAccountState> _mapUsernameChangedToState(String username) async* {
    yield currentState.updateUsername(
      isUsernameValid: Validators.isValidUsername(username),
    );
  }

  Stream<ModifyAccountState> _mapFormSubmittedToState(
      String password, String email, String username
  ) async* {
    yield ModifyAccountState.loading();

    // Check if username is used
    bool isUsernameUsed = false;
    await reference.where('displayName', isEqualTo: username).getDocuments().then((user) {
      if (user.documents.isEmpty) {
        isUsernameUsed = false;
      } else {
        isUsernameUsed = true;
      }
    });

    try {
      if(isUsernameUsed){
        yield ModifyAccountState.failure_ERROR_USERNAME_ALREADY_IN_USE();
      }
      else{
        if(password.isNotEmpty) {
          await _userRepository.resetPassword(password: password);
        }
        else if(email.isNotEmpty) {
          await _userRepository.resetEmail(email: email);
        }
        else if(username.isNotEmpty) {
          await _userRepository.resetUsername(username: username);
        }
        yield ModifyAccountState.success();
      }

    } catch (e) {
      switch(e.code) {
        case "ERROR_WEAK_PASSWORD":
          yield ModifyAccountState.failure_ERROR_WEAK_PASSWORD();
          break;
        case "ERROR_REQUIRES_RECENT_LOGIN":
          yield ModifyAccountState.failure_ERROR_REQUIRES_RECENT_LOGIN();
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          yield ModifyAccountState.failure_ERROR_EMAIL_ALREADY_IN_USE();
          break;
        case "ERROR_INVALID_CREDENTIAL":
          yield ModifyAccountState.failure_ERROR_INVALID_CREDENTIAL();
          break;
      }
    }

  }

}