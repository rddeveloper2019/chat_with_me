import 'dart:math';

import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/services/navigation_service.dart';
import 'package:chat_with_me/widgets/app_button.dart';
import 'package:chat_with_me/widgets/app_link.dart';
import 'package:chat_with_me/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthProvider auth;
  late NavigationService navigationService;

  final loginFormKey = GlobalKey<FormState>();
  String? email = '';
  String? password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    auth = Provider.of<AuthProvider>(context);
    navigationService = GetIt.I<NavigationService>();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        height: height * 0.98,
        width: width * 0.97,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Chat with Me!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: loginFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppTextField(
                    onSave: (String? value) {
                      setState(() {
                        email = value;
                      });
                    },
                    regex: r'^[^@]+@[^@]+\.[^@]+$',
                    hintText: 'Email',
                  ),
                  SizedBox(height: 20),
                  AppTextField(
                    onSave: (String? value) {
                      setState(() {
                        password = value;
                      });
                    },
                    regex: r'^.{6,}$',
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  AppButton(
                    onPressed: () {
                      if (loginFormKey.currentState!.validate()) {
                        loginFormKey.currentState?.save();
                        auth.loginUsingEmailAndPassword(
                          email: email!,
                          password: password!,
                        );
                      }
                    },
                    name: 'Log In',
                  ),
                  SizedBox(height: 10),
                  AppLink(
                    onClick: () =>
                        GetIt.I<NavigationService>().navigateToRoute('/'),
                    text: 'Need an account?',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
