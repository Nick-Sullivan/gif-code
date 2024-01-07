abstract class IAmplifyAuthenticator {
  Future<void> signUpUser(String email, String password);
  Future<void> confirmUser(String username, String confirmationCode);
  Future<void> signInUser(String email, String password);
  Future<void> signOutUser();
  Future<bool> isUserSignedIn();
  Future<String> getCurrentUserEmail();
}
