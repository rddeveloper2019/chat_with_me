import 'package:chat_with_me/services/navigation_service.dart';
import 'package:chat_with_me/widgets/app_button.dart';
import 'package:chat_with_me/widgets/app_link.dart';
import 'package:chat_with_me/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _loginFormKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _width * 0.03,
          vertical: _height * 0.02,
        ),
        height: _height * 0.98,
        width: _width * 0.97,
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
              key: _loginFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppTextField(
                    onSave: (String? value) {},
                    regex: r'^[^@]+@[^@]+\.[^@]+$',
                    hintText: 'Email',
                  ),
                  SizedBox(height: 20),
                  AppTextField(
                    onSave: (String? value) {},
                    regex: r'^.{6,}$',
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  AppButton(onPressed: () {}, name: 'Log In'),
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
