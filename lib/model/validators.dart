class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
//  static final RegExp _usernameRegExp = RegExp(
//    r'^[a-zA-Z0-9-]{4,15}$',
//  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidUsername(String username) {
    return username.length <= 15 && username.length >= 4;
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}