class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _usernameRegExp = RegExp(
    r'^[a-zA-Z0-9-]{3,18}$',
  );
//  static final RegExp _passwordRegExp = RegExp(
//    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
//  );

  static final RegExp _postRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]{1, 200}'
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidUsername(String username) {
    return _usernameRegExp.hasMatch(username);
  }

  static isValidPassword(String password) {
    return password.length <= 20 && password.length >= 8;
  }

  static isValidPostText(String postText) {
    return _postRegExp.hasMatch(postText);
  }
}