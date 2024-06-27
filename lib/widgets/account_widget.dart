import 'package:flutter/material.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget({
    Key? key,
    required this.title,
    required this.usernameController,
    required this.passwordController,
  }) : super(key: key);

  final String title;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: usernameController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Username',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Password',
          ),
        ),
      )
    ]);
  }
}
