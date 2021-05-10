class DataValidator {
  static bool isValidPhoneNumber(String string) =>
      new RegExp(r"^(06|\+336)\d{9}$")
          .hasMatch(string);

  static bool isValidEmail(String string) => new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(string);
}