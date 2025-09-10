//extension to check if the email is valid or not
extension EmailValidator on String {
  bool isValidEmail() {
    final RegExp regex = RegExp(
      r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b',
      caseSensitive: false,
      multiLine: false,
    );
    return regex.hasMatch(this);
  }
}

extension DoubleValidator on String {
  bool isValidDouble() {
    // Try to parse the string as a double
    return double.tryParse(this) != null;
  }
}

extension phoneNumberValidator on String {
  bool isValidPhone() {
    // Regular expression for a valid phone number with country code
    final RegExp phoneRegex = RegExp(
      r'^\+\d[\d\s-()]+$', // This regex matches numbers with a mandatory country code and common separators
    );

    return phoneRegex.hasMatch(this);
  }
}

//extension to check if the user name is valid
extension UsernameValidator on String {
  bool isValidUsername() {
    return this.length >= 3 &&
        !RegExp(r'^\d+$').hasMatch(this); // Checks if it's not only numbers
  }
}

//extension to check if the passowrd contains uppercase letters
extension UpperCaseValidator on String {
  bool isUpperCase() {
    return this
        .contains(RegExp(r'[A-Z]')); // Checks if it contains uppercase letters
  }
}

//extension to check if the passowrd contains lowercase letters
extension LowerCaseValidator on String {
  bool isLowerCase() {
    return this
        .contains(RegExp(r'[a-z]')); // Checks if it contains lowercase letters
  }
}

//extension to check if the passowrd contains atleast 1 digit
extension DigitValidator on String {
  bool isContainDigit() {
    return this
        .contains(RegExp(r'[0-9]')); // Checks if it contains atleast 1 digit
  }

  bool isOnlyDigits() {
    return RegExp(r'^\d+$').hasMatch(this);
  }
}

//extension to check if the passowrd contains a special character
extension SpecialCharacterValidator on String {
  bool isContainSpecialCharacter() {
    return this.contains(RegExp(
        r'[!@#$%^&*(),.?":{}|<>]')); // Checks if it contains a special character
  }
}

//extension to check if the device IMEI starts with 865
extension NumberValidation on String {
  bool isValidIMEI() {
    //checking if the string is not null and has at least 15 characters
    if (this.length >= 15) {
      //checking if the imei contains digits
      String digits = this.substring(0);
      return int.tryParse(digits) != null;
    }
    return false;
  }
}
