import 'package:flutter/material.dart';
import 'package:myapp/widgets/AdminPage/admin_page.dart';
import 'package:myapp/widgets/AdminPage/create_users_page.dart';
import 'package:myapp/widgets/AdminPage/list_users_page.dart';
import 'package:myapp/widgets/UserPage/user_page.dart';
import 'package:myapp/widgets/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/home': (context) => LoginScreen(),
        '/userpage': (context) => UserPage(),
        '/adminpage': (context) => AdminPage(),
        '/createusers': (context) => CreateUsersPage(),
        '/listusers': (context) => ListUsersPage(),
      },
      initialRoute: '/home',
    );
  }
}
