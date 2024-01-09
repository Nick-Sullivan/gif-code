import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';
import 'package:qr_gif/widgets/auth/sign_up_view.dart';
import 'package:qr_gif/widgets/auth/signed_in_view.dart';

class AccountScreen extends StatelessWidget {
  final authController = GetIt.instance<AuthController>();

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Account', key: Key("accountTitle")),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget buildBody(BuildContext context) {
    return ListenableBuilder(
        listenable: authController,
        builder: (BuildContext context, Widget? child) {
          if (authController.isSignedIn) {
            return SignedInView(
                controller: authController, key: const Key('signedInView'));
          } else {
            return SignUpView(key: const Key('signUpView'));
          }
        });
  }
}
