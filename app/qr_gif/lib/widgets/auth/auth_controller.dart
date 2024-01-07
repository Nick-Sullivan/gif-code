import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/infrastructure/interfaces/amplify_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class AuthController extends ChangeNotifier {
  final IAmplifyAuthenticator auth = getIt<IAmplifyAuthenticator>();

  bool _isLoading = false;
  bool _isAwaitingConfirmation = false;
  bool _isSignedIn = false;
  String? _email;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isAwaitingConfirmation => _isAwaitingConfirmation;
  set isAwaitingConfirmation(bool value) {
    _isAwaitingConfirmation = value;
    notifyListeners();
  }

  bool get isSignedIn => _isSignedIn;
  set isSignedIn(bool value) {
    _isSignedIn = value;
    notifyListeners();
  }

  String? get userEmail => _email;
  set userEmail(String? value) {
    _email = value;
    notifyListeners();
  }

  String? get errorMessage => _errorMessage;
  set errorMessage(String? value) {
    _errorMessage = value;
    if (value != null) {
      notifyListeners();
    }
  }

  Future<void> signUpUser(String email, String password) async {
    isLoading = true;
    try {
      await auth.signUpUser(email, password);
      isAwaitingConfirmation = true;
    } on AuthException catch (e) {
      errorMessage = e.message;
    }
    isLoading = false;
  }

  Future<void> confirmUser(
      String email, String password, String confirmationCode) async {
    isLoading = true;
    try {
      await auth.confirmUser(email, confirmationCode);
      isAwaitingConfirmation = false;
      await auth.signInUser(email, password);
      await loadUserDetailsIfSignedIn();
      // await _saveCredentials(email, password);
      // userEmail = email;
      // isSignedIn = true;
    } on AuthException catch (e) {
      errorMessage = e.message;
    }
    isLoading = false;
  }

  Future<void> signInUser(String email, String password) async {
    isLoading = true;
    try {
      await auth.signInUser(email, password);
      // await _saveCredentials(email, password);
      await loadUserDetailsIfSignedIn();
      // userEmail = email;
      // isSignedIn = true;
    } on AuthException catch (e) {
      errorMessage = e.message;
    }
    isLoading = false;
  }

  // Future<void> signInUserIfCredentialsSaved() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final email = prefs.getString('email');
  //   final password = prefs.getString('password');
  //   if (email == null || password == null) {
  //     return;
  //   }
  //   await auth.signInUser(email, password);
  //   userEmail = email;
  //   isSignedIn = true;
  // }

  Future<void> loadUserDetailsIfSignedIn() async {
    final isSignedIn = await auth.isUserSignedIn();
    if (!isSignedIn) {
      return;
    }
    userEmail = await auth.getCurrentUserEmail();
    this.isSignedIn = isSignedIn;
  }

  Future<void> signOutUser() async {
    isLoading = true;
    await auth.signOutUser();
    // await _clearCredentials();
    isSignedIn = false;
    isLoading = false;
  }

  Future<void> _saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> _clearCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }
}
