class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
//  static final RegExp _usernameRegExp = RegExp(
//    r'^[a-zA-Z0-9-]{4,15}$',
//  );
//  static final RegExp _passwordRegExp = RegExp(
//    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
//  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidUsername(String username) {
    return username.length <= 15 && username.length >= 2;
  }

  static isValidPassword(String password) {
    return password.length <= 20 && password.length >= 8;
  }
}