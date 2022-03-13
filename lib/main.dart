import 'package:flutter/material.dart';
import 'package:massive_messages/providers/login_form_provider.dart';
import 'package:massive_messages/screens/screens.dart';
import 'package:massive_messages/service/access_token.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(child: const MyApp(), providers: [
      ChangeNotifierProvider(
        create: (_) => AccessToken(),
        lazy: false,
      ),
      ChangeNotifierProvider(
        create: (_) => LoginFormProvider(),
        lazy: true,
      ),
    ]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginform = Provider.of<LoginFormProvider>(context);
    return MaterialApp(
      title: 'Send Messages',
      debugShowCheckedModeBanner: false,
      initialRoute: loginform.isAuth ? 'home' : 'login',
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'messages': (_) => const SendMessagesScreen()
      },
      theme:
          ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[300]),
    );
  }
}
