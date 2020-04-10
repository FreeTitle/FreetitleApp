import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ModifyAccountEvent extends Equatable {
  ModifyAccountEvent([List props = const []]) : super(props);
}

class PasswordChanged extends ModifyAccountEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class EmailChanged extends ModifyAccountEvent{
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class UsernameChanged extends ModifyAccountEvent{
  final String username;

  UsernameChanged({@required this.username}) : super([username]);

  @override
  String toString() => 'UsernameChanged { username: $username }';
}

class Submitted extends ModifyAccountEvent {
  final String password;
  final String email;
  final String username;

  Submitted({@required this.password, @required this.email, @required this.username})
      : super([password, email, username]);

  @override
  String toString() {
    return 'Submitted { password: $password, email: $email, username: $username}';
  }
}
