import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';

class SignUpView extends StatefulWidget {
  final AuthController controller;
  const SignUpView({super.key, required this.controller});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.controller,
        builder: (BuildContext context, Widget? child) {
          if (widget.controller.errorMessage != null) {
            final text = widget.controller.errorMessage!;
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(text),
                      key: const Key('errorMessage'),
                    )));
            widget.controller.errorMessage = null;
          }
          if (widget.controller.isLoading) {
            return buildLoading();
          }
          if (widget.controller.isAwaitingConfirmation) {
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
                widget.controller
                    .signInUser(emailController.text, passwordController.text);
              },
            ),
            TextButton(
              key: const Key("signUpButton"),
              child: const Text('SIGN UP'),
              onPressed: () async {
                widget.controller
                    .signUpUser(emailController.text, passwordController.text);
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
                widget.controller.confirmUser(emailController.text,
                    passwordController.text, confirmationCodeController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
