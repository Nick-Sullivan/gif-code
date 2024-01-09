import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';

class SignedInView extends StatelessWidget {
  final AuthController controller;
  const SignedInView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Hello ${controller.userEmail}"),
                  TextButton(
                    key: const Key("signOutButton"),
                    child: const Text('SIGN OUT'),
                    onPressed: () async {
                      controller.signOutUser();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildLoading() {
    return const Center(child: CircularProgressIndicator(key: Key('loading')));
  }
}
