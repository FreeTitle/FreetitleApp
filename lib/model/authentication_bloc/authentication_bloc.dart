import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/model/user_repository.dart';


class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /**
   * var:
   *  _userRepository
   * initialState
   *
   */
  final UserRepository _userRepository;

  // named argument
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  // 就是一个 string, 代表是不是 initialized
  @override
  AuthenticationState get initialState => Uninitialized();

  // default method called when dispatched
  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        String name;
        await _userRepository.getUser().then((user){
          name = user.email;
        });
        // 返回 Authenticated object
        yield Authenticated(name);
      } else {
        // 返回 Unauthenticated object
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    String name;
    await _userRepository.getUser().then((user){
      name = user.email;
    });
    yield Authenticated(name);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}