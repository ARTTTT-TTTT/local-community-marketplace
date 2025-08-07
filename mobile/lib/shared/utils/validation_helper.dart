class ValidationHelper {
  // Email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Password validation with Thai requirements
  static bool isValidPassword(String password) {
    // ABC | abc | 123 | 8-20 ตัวอักษร
    if (password.length < 8 || password.length > 20) {
      return false;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));

    return hasUppercase && hasLowercase && hasDigits;
  }

  // Get password validation message
  static String getPasswordValidationMessage(String password) {
    if (password.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }

    if (password.length < 8) {
      return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
    }

    if (password.length > 20) {
      return 'รหัสผ่านต้องไม่เกิน 20 ตัวอักษร';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'รหัสผ่านต้องมีตัวอักษรภาษาอังกฤษตัวใหญ่';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'รหัสผ่านต้องมีตัวอักษรภาษาอังกฤษตัวเล็ก';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'รหัสผ่านต้องมีตัวเลข';
    }

    return '';
  }

  // Phone number validation (Thai format)
  static bool isValidThaiPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone) && phone.startsWith('0');
  }

  // Name validation
  static bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  // General validation for required fields
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอก$fieldName';
    }
    return null;
  }

  // Password confirmation validation
  static String? validatePasswordConfirmation(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }

    if (value != originalPassword) {
      return 'รหัสผ่านไม่ตรงกัน';
    }

    return null;
  }
}
