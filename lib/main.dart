import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/screens/account_screen.dart';
import '/screens/home_screen.dart';
import '/screens/login_screen.dart';
import '/screens/reset_password_screen.dart';
import '/screens/signup_screen.dart';
import '/screens/verify_email_screen.dart';
import '/services/firebase_streem.dart';

// Firebase Авторизация - Сценарии:
//    Войти - Почта / Пароль
//    Личный кабинет
//    Зарегистрироваться - Почта / Пароль два раза
//        Подтвердить почту - Отправить письмо снова / Отменить
//    Сбросить пароль - Почта

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyCXVV_ibNWnnE97RmbJNP5R7BCCUZH6jy4',
        appId: '1:1081180866965:android:b2195241363f8c5286ce9c',
        messagingSenderId: '1081180866965',
        projectId: 'travel-agency-fd2cf',
            )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/',
    );
  }
}