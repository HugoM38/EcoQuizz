import 'package:ecoquizz/ui/defi/defi_home.dart';
import 'package:ecoquizz/ui/auth/signup_page.dart';
import 'package:ecoquizz/ui/auth/signup_viewmodel.dart';
import 'package:ecoquizz/ui/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:ecoquizz/models/auth_model.dart';
import 'package:ecoquizz/ui/auth/login_page.dart';
import 'package:ecoquizz/ui/auth/login_viewmodel.dart';
import 'package:ecoquizz/utils/auth_observer.dart';
import 'package:provider/provider.dart';

void main() {
 runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (context) => AuthModel()),
      ChangeNotifierProvider(create: (context) => SignupViewModel()),
    ],
    child: const EcoQuizz(),
  ));
}

class EcoQuizz extends StatelessWidget {
  const EcoQuizz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoQuizz',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const DefiPage(),
        '/user-page': (context) => const UserPage(),
      },
      navigatorObservers: [AuthObserver()],
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFA5B452),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF5C573E),
          onSecondary: Color(0xFFFFFFFF),
          tertiary: Color(0xFFEEE8AA),
          onTertiary: Color(0xFFA5B452),
          error: Colors.red,
          onError: Color.fromARGB(255, 1, 1, 1),
          surface: Color(0xFFEEE8AA),
          onSurface: Color(0xFFA5B452)
        ),
      ),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
    );
  }
}