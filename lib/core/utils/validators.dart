import 'package:mood_prints/core/extensions/validation.dart';

class ValidationService {
  //private constructor
  ValidationService._privateConstructor();

  //singleton instance variable
  static ValidationService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to ValidationService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static ValidationService get instance {
    _instance ??= ValidationService._privateConstructor();
    return _instance!;
  }

  //empty validator
  String? emptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    return null;
  }

  //email validator
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    } else if (value.isValidEmail() == false) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String? linkValidator(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter url';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid url';
    }
    return null;
  }

  String? digitValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (value.isOnlyDigits() == false) {
      return 'Invalid phone number';
    } else {
      return null;
    }
  }

  String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (value.isValidPhone() == false) {
      return 'Invalid phone number';
    } else {
      return null;
    }
  }

  //username validator
  String? userNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    } else if (value.isValidUsername() == false) {
      return 'Invalid name';
    } else {
      return null;
    }
  }

  //password validator
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 6 characters long';
    }

    if (password.isUpperCase() == false) {
      return 'Password must contain at least one uppercase letter';
    }

    if (password.isLowerCase() == false) {
      return 'Password must contain at least one lowercase letter';
    }

    if (password.isContainDigit() == false) {
      return 'Password must contain at least one digit';
    }

    if (password.isContainSpecialCharacter() == false) {
      return 'Password must contain at least one special character';
    }

    return null; // Return null if the password is valid
  }

  //password match function
  String? validateMatchPassword(String value, String password) {
    if (value.isEmpty) {
      return 'Please enter your password again';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  //device IMEI validator
  String? imeiValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your device IMEI';
    } else if (value.isValidIMEI() == false) {
      return 'Invalid IMEI';
    } else {
      return null;
    }
  }

  // Phone number and Email Enter validation
  // purpose : flagged when enter email or phone
  String? containsNumberOrEmail(String? message) {
    // Regular expression for detecting numbers
    final numberPattern = RegExp(r'\b\d{10,15}\b');

    // Regular expression for detecting email addresses
    final emailPattern =
        RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');

    if (message == null || message.isEmpty) {
      return 'Enter Your Message';
    } else if (numberPattern.hasMatch(message)) {
      return 'Cannot Add Phone Number';
    } else if (emailPattern.hasMatch(message)) {
      return 'Cannot Add Email';
    } else {
      return null;
    }

    // Check if the message contains a number or email
    // return numberPattern.hasMatch(message) || emailPattern.hasMatch(message);
  }
}
