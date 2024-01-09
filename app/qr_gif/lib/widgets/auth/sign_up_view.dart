import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';

class SignUpView extends StatelessWidget {
  final authController = GetIt.instance<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationCodeController =
      TextEditingController();

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: authController,
        builder: (BuildContext context, Widget? child) {
          if (authController.errorMessage != null) {
            final text = authController.errorMessage!;
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(text),
                      key: const Key('errorMessage'),
                    )));
            authController.errorMessage = null;
          }
          if (authController.isLoading) {
            return buildLoading();
          }
          if (authController.isAwaitingConfirmation) {
            return buildAwaitingConfirmation();
          }
          return buildSignUp();
        });
  }

  Widget buildLoading() {
    return const Center(child: CircularProgressIndicator(key: Key('loading')));
  }

  Widget buildSignUp() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                key: const Key("emailText"),
                controller: emailController
                  ..text = "nick.dave.sullivan@gmail.com",
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter username",
                    contentPadding: EdgeInsets.all(20.0)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                key: const Key("passwordText"),
                controller: passwordController..text = "password",
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter password",
                    contentPadding: EdgeInsets.all(20.0)),
              ),
            ),
            TextButton(
              key: const Key("signInButton"),
              child: const Text('SIGN IN'),
              onPressed: () async {
                authController.signInUser(
                    emailController.text, passwordController.text);
              },
            ),
            TextButton(
              key: const Key("signUpButton"),
              child: const Text('SIGN UP'),
              onPressed: () async {
                authController.signUpUser(
                    emailController.text, passwordController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAwaitingConfirmation() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("A confirmation code has been sent to ${emailController.text}",
                textAlign: TextAlign.center),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                key: const Key("confirmationCodeText"),
                controller: confirmationCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter confirmation code",
                    contentPadding: EdgeInsets.all(20.0)),
              ),
            ),
            TextButton(
              key: const Key("confirmationCodeButton"),
              child: const Text('CONFIRM SIGN UP'),
              onPressed: () async {
                authController.confirmUser(emailController.text,
                    passwordController.text, confirmationCodeController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
