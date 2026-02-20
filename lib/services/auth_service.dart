import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/auth_error_handler.dart';

class AuthService {

  AuthService._();
  static final instance = AuthService._();

  final SupabaseClient client = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );
      return response;
    } on AuthException catch (e) {
      // Log for debugging but throw user-friendly message
      print('AuthException during signUp: ${e.message}, code: ${e.statusCode}');
      final friendlyMessage = AuthErrorHandler.getErrorMessage(
        e.statusCode?.toString() ?? e.message,
        message: e.message,
      );
      throw Exception(friendlyMessage);
    } catch (e) {
      print('Unexpected error during sign up: $e');
      throw Exception('Unable to create account. Please check your connection and try again.');
    }
  }


  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      // Log full error for debugging
      print('AuthException: ${e.message}, statusCode: ${e.statusCode}');
      
      // Map to user-friendly error message
      final friendlyMessage = AuthErrorHandler.getErrorMessage(
        e.statusCode?.toString() ?? 'unknown',
        message: e.message,
      );
      throw Exception(friendlyMessage);
    } catch (e) {
      print('Unexpected error during sign in: $e');
      throw Exception('Unable to sign in. Please check your connection and try again.');
    }
  }


  Future<void> signInWithGoogle({String? redirectTo}) async {
    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo:
            redirectTo ?? (kIsWeb ? null : 'io.supabase.flutter://callback'),
        scopes: 'email profile',
      );
    } on AuthException catch (e) {
      final friendlyMessage = AuthErrorHandler.getErrorMessage(
        e.statusCode?.toString() ?? 'unknown',
        message: e.message,
      );
      throw Exception(friendlyMessage);
    } catch (e) {
      print('Unexpected error during Google sign in: $e');
      throw Exception('Unable to sign in with Google. Please try again.');
    }
  }


  Future<void> signInWithApple({String? redirectTo}) async {
    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo:
            redirectTo ?? (kIsWeb ? null : 'io.supabase.flutter://callback'),
        scopes: 'name email',
      );
    } on AuthException catch (e) {
      final friendlyMessage = AuthErrorHandler.getErrorMessage(
        e.statusCode?.toString() ?? 'unknown',
        message: e.message,
      );
      throw Exception(friendlyMessage);
    } catch (e) {
      print('Unexpected error during Apple sign in: $e');
      throw Exception('Unable to sign in with Apple. Please try again.');
    }
  }


  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Session? get currentSession => client.auth.currentSession;
  User? get currentUser => client.auth.currentUser;

  String getUserName() {
    final user = currentUser;
    if (user == null) return 'Guest';
    // Try to get name from user metadata
    final metadata = user.userMetadata;
    if (metadata != null && metadata['name'] != null) {
      return metadata['name'] as String;
    }
    // Fallback to email username
    return user.email?.split('@').first ?? 'User';
  }
}
