import 'package:flutter/material.dart';
import 'package:qr_gif/widgets/auth/auth_controller.dart';

class SignedInView extends StatefulWidget {
  final AuthController controller;
  const SignedInView({super.key, required this.controller});

  @override
  State<SignedInView> createState() => _SignedInViewState();
}

class _SignedInViewState extends State<SignedInView> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.controller,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Hello ${widget.controller.userEmail}"),
                  TextButton(
                    key: const Key("logOutButton"),
                    child: const Text('LOG OUT'),
                    onPressed: () async {
                      widget.controller.signOutUser();
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
