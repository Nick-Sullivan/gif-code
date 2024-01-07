import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';
import 'package:qr_gif/widgets/auth/sign_up_view.dart';
import 'package:qr_gif/widgets/auth/signed_in_view.dart';

final getIt = GetIt.instance;

class AccountScreen extends StatefulWidget {
  final AuthController authController;

  const AccountScreen({super.key, required this.authController});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
        listenable: widget.authController,
        builder: (BuildContext context, Widget? child) {
          if (widget.authController.isSignedIn) {
            return SignedInView(
                controller: widget.authController,
                key: const Key('signedInView'));
          } else {
            return SignUpView(
                controller: widget.authController,
                key: const Key('signUpView'));
          }
        });
  }
}
