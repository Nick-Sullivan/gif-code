import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/amplifyconfiguration.dart';
import 'package:qr_gif/infrastructure/interfaces/amplify_auth.dart';

class AuthController extends ChangeNotifier {
  final auth = GetIt.instance.get<IAmplifyAuthenticator>();

  bool _isLoading = true;
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

  Future<void> configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      try {
        await Amplify.configure(amplifyconfig);
      } on AmplifyAlreadyConfiguredException catch (e) {
        debugPrint(e.message);
      }
      await loadUserDetailsIfSignedIn();
      safePrint('Successfully configured');
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
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

  Future<void> loadUserDetailsIfSignedIn() async {
    isLoading = true;
    await Future.delayed(const Duration(seconds: 5));
    final isIn = await auth.isUserSignedIn();
    if (!isIn) {
      return;
    }
    userEmail = await auth.getCurrentUserEmail();
    isSignedIn = isIn;
    isLoading = false;
  }

  Future<void> signOutUser() async {
    isLoading = true;
    await auth.signOutUser();
    // await _clearCredentials();
    isSignedIn = false;
    isLoading = false;
  }
}
