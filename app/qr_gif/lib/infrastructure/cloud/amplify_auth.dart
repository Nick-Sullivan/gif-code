import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:qr_gif/infrastructure/interfaces/amplify_auth.dart';

// https://docs.amplify.aws/flutter/build-a-backend/auth/enable-sign-in/
class AmplifyAuthenticator implements IAmplifyAuthenticator {
  @override
  Future<void> signUpUser(String email, String password) async {
    final userAttributes = {
      AuthUserAttributeKey.email: email,
    };
    final result = await Amplify.Auth.signUp(
      username: email,
      password: password,
      options: SignUpOptions(
        userAttributes: userAttributes,
      ),
    );
    await _handleSignUpResult(result);
  }

  @override
  Future<void> confirmUser(String username, String confirmationCode) async {
    final result = await Amplify.Auth.confirmSignUp(
      username: username,
      confirmationCode: confirmationCode,
    );
    await _handleSignUpResult(result);
  }

  @override
  Future<void> signInUser(String email, String password) async {
    final result = await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
    await _handleSignInResult(result);
  }

  @override
  Future<void> signOutUser() async {
    await Amplify.Auth.signOut();
  }

  @override
  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  @override
  Future<String> getCurrentUserEmail() async {
    final userAttributes = await Amplify.Auth.fetchUserAttributes();
    for (final attribute in userAttributes) {
      if (attribute.userAttributeKey.key == "email") {
        return attribute.value;
      }
    }
    throw Exception("Couldn't find user email");
  }

  Future<void> _handleSignUpResult(SignUpResult result) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignUpStep.done:
        safePrint('Sign up is complete');
        break;
    }
  }

  Future<void> _handleSignInResult(SignInResult result) async {
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.continueSignInWithMfaSelection:
        break;
      case AuthSignInStep.continueSignInWithTotpSetup:
        break;
      case AuthSignInStep.confirmSignInWithTotpMfaCode:
        break;
      case AuthSignInStep.confirmSignInWithSmsMfaCode:
        // final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        // _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignInStep.confirmSignInWithNewPassword:
        // safePrint('Enter a new password to continue signing in');
        break;
      case AuthSignInStep.confirmSignInWithCustomChallenge:
        // final parameters = result.nextStep.additionalInfo;
        // final prompt = parameters['prompt']!;
        // safePrint(prompt);
        break;
      case AuthSignInStep.resetPassword:
        // final resetResult = await Amplify.Auth.resetPassword(
        //   username: username,
        // );
        // await _handleResetPasswordResult(resetResult);
        break;
      case AuthSignInStep.confirmSignUp:
        // Resend the sign up code to the registered device.
        // final resendResult = await Amplify.Auth.resendSignUpCode(
        //   username: username,
        // );
        // _handleCodeDelivery(resendResult.codeDeliveryDetails);
        break;
      case AuthSignInStep.done:
        safePrint('Sign in is complete');
        break;
    }
  }

  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
  }
}
