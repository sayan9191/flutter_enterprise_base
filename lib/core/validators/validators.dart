import '../extensions/string_extensions.dart';

abstract final class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!value.isValidEmail) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != length || int.tryParse(value) == null) {
      return 'Enter a valid $length-digit OTP';
    }
    return null;
  }
}
