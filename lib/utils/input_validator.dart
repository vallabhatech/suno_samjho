/// Provides real-time input validation with user-friendly error messages
class InputValidator {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    
    final trimmed = value.trim();
    
    // Check for spaces
    if (trimmed.contains(' ')) {
      return 'Email address cannot contain spaces';
    }
    
    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address (e.g., name@example.com)';
    }
    
    // Check for common typos
    if (trimmed.endsWith('.con')) {
      return 'Did you mean .com?';
    }
    if (trimmed.endsWith('.co,')) {
      return 'Did you mean .com?';
    }
    if (trimmed.contains('@@')) {
      return 'Email contains invalid characters';
    }
    
    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value, {bool checkStrength = false}) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    if (value.length > 128) {
      return 'Password is too long (maximum 128 characters)';
    }
    
    if (checkStrength) {
      // Check for at least one letter
      if (!value.contains(RegExp(r'[a-zA-Z]'))) {
        return 'Password must contain at least one letter';
      }
      
      // Check for at least one number
      if (!value.contains(RegExp(r'[0-9]'))) {
        return 'Password must contain at least one number';
      }
      
      // Optional: Check for special character
      // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      //   return 'Password must contain at least one special character';
      // }
    }
    
    return null;
  }

  /// Validates password confirmation
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (password != confirmPassword) {
      return 'Passwords do not match. Please try again.';
    }
    
    return null;
  }

  /// Validates name input
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (trimmed.length > 50) {
      return 'Name is too long (maximum 50 characters)';
    }
    
    // Check for valid characters
    final validNameRegex = RegExp(r"^[a-zA-Z\s\-'.]+$");
    if (!validNameRegex.hasMatch(trimmed)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    // Check for consecutive spaces
    if (trimmed.contains('  ')) {
      return 'Name cannot contain consecutive spaces';
    }
    
    return null;
  }

  /// Validates that a field is not empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  /// Get password strength indicator (0-4 scale)
  static int getPasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 6) strength++;
    if (password.length >= 10) strength++;
    if (password.contains(RegExp(r'[a-z]')) && password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    // Cap at 4
    return strength > 4 ? 4 : strength;
  }

  /// Get password strength label
  static String getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
        return 'Too short';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  /// Get password strength color
  static int getPasswordStrengthColor(int strength) {
    switch (strength) {
      case 0:
        return 0xFFE53935; // Red
      case 1:
        return 0xFFFF5722; // Deep Orange
      case 2:
        return 0xFFFF9800; // Orange
      case 3:
        return 0xFF4CAF50; // Green
      case 4:
        return 0xFF2E7D32; // Dark Green
      default:
        return 0xFF9E9E9E; // Grey
    }
  }
}
