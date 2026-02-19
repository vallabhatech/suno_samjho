/// Maps Supabase and authentication errors to user-friendly messages
class AuthErrorHandler {
  /// Get user-friendly error message from Supabase AuthException
  static String getErrorMessage(String errorCode, {String? message}) {
    // Map common Supabase error codes to user-friendly messages
    switch (errorCode.toLowerCase()) {
      // Invalid credentials
      case 'invalid_credentials':
      case 'invalid_login_credentials':
        return 'The email or password you entered is incorrect. Please try again.';
      
      // Email errors
      case 'email_not_confirmed':
        return 'Please verify your email address before signing in. Check your inbox for a confirmation link.';
      
      case 'user_not_found':
        return 'No account found with this email. Please check your email or sign up.';
      
      case 'email_exists':
      case 'user_already_registered':
        return 'An account with this email already exists. Please sign in or use a different email.';
      
      case 'email_address_invalid':
      case 'invalid_email':
        return 'Please enter a valid email address.';
      
      // Password errors
      case 'weak_password':
        return 'Your password is too weak. Please use at least 6 characters with a mix of letters and numbers.';
      
      case 'same_password':
        return 'Your new password must be different from your current password.';
      
      // Rate limiting
      case 'over_email_send_rate_limit':
        return 'Too many attempts. Please wait a few minutes before trying again.';
      
      case 'over_request_rate_limit':
        return 'Too many requests. Please wait a moment and try again.';
      
      // OAuth errors
      case 'provider_disabled':
        return 'This sign-in method is currently unavailable. Please try another method.';
      
      case 'user_already_exists':
        return 'An account with this email already exists using a different sign-in method.';
      
      // Network/timeout errors
      case 'request_timeout':
        return 'Connection timed out. Please check your internet connection and try again.';
      
      case 'network_error':
      case 'connection_error':
        return 'Unable to connect to the server. Please check your internet connection.';
      
      // Generic auth errors
      case 'unauthorized':
      case 'forbidden':
        return 'You do not have permission to perform this action.';
      
      case 'unexpected_failure':
        return 'Something went wrong. Please try again later.';
      
      default:
        // If we have a specific message from Supabase, clean it up
        if (message != null && message.isNotEmpty) {
          return _cleanErrorMessage(message);
        }
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Clean up raw error messages to be more user-friendly
  static String _cleanErrorMessage(String message) {
    // Remove technical prefixes
    String cleaned = message
        .replaceAll('Exception: ', '')
        .replaceAll('AuthException: ', '')
        .replaceAll('Error: ', '');
    
    // Map common raw messages
    if (cleaned.toLowerCase().contains('invalid') && 
        cleaned.toLowerCase().contains('credential')) {
      return 'The email or password you entered is incorrect. Please try again.';
    }
    
    if (cleaned.toLowerCase().contains('email') && 
        cleaned.toLowerCase().contains('confirmed')) {
      return 'Please verify your email address before signing in.';
    }
    
    if (cleaned.toLowerCase().contains('password') && 
        cleaned.toLowerCase().contains('weak')) {
      return 'Your password is too weak. Please use at least 6 characters.';
    }
    
    if (cleaned.toLowerCase().contains('user') && 
        cleaned.toLowerCase().contains('already') &&
        cleaned.toLowerCase().contains('registered')) {
      return 'An account with this email already exists. Please sign in.';
    }
    
    // If message is too technical, return generic friendly message
    if (cleaned.contains('statusCode') || 
        cleaned.contains('stack trace') ||
        cleaned.contains('at ') ||
        cleaned.length > 100) {
      return 'Something went wrong. Please try again.';
    }
    
    return cleaned;
  }

  /// Get field-specific validation error message
  static String? validateField(String fieldName, String value, {String? confirmValue}) {
    switch (fieldName) {
      case 'email':
        return _validateEmail(value);
      case 'password':
        return _validatePassword(value);
      case 'confirm_password':
        return _validateConfirmPassword(value, confirmValue);
      case 'name':
        return _validateName(value);
      default:
        return null;
    }
  }

  static String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter your email address';
    }
    
    // Basic email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address (e.g., name@example.com)';
    }
    
    return null;
  }

  static String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter a password';
    }
    
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    if (password.length > 128) {
      return 'Password is too long (maximum 128 characters)';
    }
    
    // Optional: Check for complexity
    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    
    if (!hasLetter || !hasNumber) {
      return 'Password should contain both letters and numbers';
    }
    
    return null;
  }

  static String? _validateConfirmPassword(String password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (password != confirmPassword) {
      return 'Passwords do not match. Please try again.';
    }
    
    return null;
  }

  static String? _validateName(String name) {
    if (name.isEmpty) {
      return 'Please enter your name';
    }
    
    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (name.length > 50) {
      return 'Name is too long (maximum 50 characters)';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final validNameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!validNameRegex.hasMatch(name)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }
}
