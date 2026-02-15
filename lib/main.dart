import 'package:chat_with_me/pages/home_page.dart';
import 'package:chat_with_me/pages/login_page.dart';
import 'package:chat_with_me/pages/register_page.dart';
import 'package:chat_with_me/pages/splash_page.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/providers/chats_page_provider.dart';
import 'package:chat_with_me/services/cloud_storage_service.dart';
import 'package:chat_with_me/services/database_service.dart';
import 'package:chat_with_me/services/media_service.dart';
import 'package:chat_with_me/services/navigation_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }

  _registerServices();

  runApp(const MainApp());
}

void _registerServices() {
  GetIt.I.registerSingleton<NavigationService>(NavigationService());
  GetIt.I.registerSingleton<MediaService>(MediaService());
  GetIt.I.registerSingleton<CloudStorageService>(CloudStorageService());
  GetIt.I.registerSingleton<DatabaseService>(DatabaseService());
  GetIt.I.registerSingleton<KeyboardVisibilityController>(
    KeyboardVisibilityController(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (context) =>
              ChatsPageProvider(auth: context.read<AuthProvider>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat With Me!',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(36, 35, 49, 1),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
        navigatorKey: GetIt.I<NavigationService>().navigatorKey,
        home: Builder(
          builder: (ctx) {
            final auth = Provider.of<AuthProvider>(ctx);
            print(auth);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(const Duration(milliseconds: 2200), () {
                if (context.mounted && auth.chatUser == null) {
                  GetIt.I<NavigationService>().removeAndNavigateToRoute(
                    '/login',
                  );
                }
              });
            });
            return const SplashPage();
          },
        ),
      ),
    );
  }
}
