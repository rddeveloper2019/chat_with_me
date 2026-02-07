import 'dart:io';

import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/services/cloud_storage_service.dart';
import 'package:chat_with_me/services/database_service.dart';
import 'package:chat_with_me/services/navigation_service.dart';
import 'package:chat_with_me/widgets/app_button.dart';
import 'package:chat_with_me/widgets/app_link.dart';
import 'package:chat_with_me/widgets/app_text_field.dart';
import 'package:chat_with_me/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthProvider auth;
  late NavigationService navigationService;
  late CloudStorageService cloudStorageService;
  late DatabaseService databaseService;

  final loginFormKey = GlobalKey<FormState>();
  String? name = '';
  String? email = '';
  String? password = '';
  String? confirmPassword = '';

  File? profileImage;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    auth = Provider.of<AuthProvider>(context);

    navigationService = GetIt.I<NavigationService>();
    cloudStorageService = GetIt.I<CloudStorageService>();
    databaseService = GetIt.I<DatabaseService>();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),

          width: width * 0.97,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileImage(
                image: profileImage,
                size: width * 0.40,
                onSelect: (File? value) {
                  setState(() {
                    profileImage = value;
                  });
                },
              ),
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
                          name = value;
                        });
                      },
                      regex: r'^.{3,}$',
                      hintText: 'Name',
                    ),
                    SizedBox(height: 15),
                    AppTextField(
                      onSave: (String? value) {
                        setState(() {
                          email = value;
                        });
                      },
                      regex: r'^[^@]+@[^@]+\.[^@]+$',
                      hintText: 'Email',
                    ),
                    SizedBox(height: 15),
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
                    SizedBox(height: 15),

                    AppButton(
                      onPressed: () async {
                        if (_isLoading || !mounted) return;

                        if (loginFormKey.currentState!.validate() &&
                            profileImage != null) {
                          loginFormKey.currentState?.save();
                          setState(() => _isLoading = true);
                          try {
                            final uid = await auth
                                .registerUsingEmailAndPassword(
                                  email: email!,
                                  password: password!,
                                );
                            final imageUrl = await cloudStorageService
                                .saveChatImageToStorage(
                                  uid: uid!,
                                  file: profileImage!,
                                );
                            await databaseService.createUser(
                              uid: uid,
                              name: name!,
                              imageUrl: imageUrl ?? '',
                              email: email!,
                            );
                            await auth.logOut();
                            await auth.loginUsingEmailAndPassword(
                              email: email!,
                              password: password!,
                            );
                          } catch (e) {
                            debugPrint('(**) => create user:  ${e}');
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        }
                      },
                      name: 'Register',
                    ),
                    SizedBox(height: 30),
                    AppLink(
                      onClick: () => GetIt.I<NavigationService>().goBack(),
                      text: 'Have an account?',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
