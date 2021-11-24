import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  final void Function() onLogin;

  @override
  Widget build(BuildContext context) => const Text("Login");
}
