import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/widgets/AdminPage/admin_page.dart';
import 'package:myapp/widgets/AdminPage/create_users_page.dart';
import 'package:myapp/widgets/AdminPage/list_users_page.dart';
import 'package:myapp/widgets/UserPage/user_page.dart';
import 'package:myapp/widgets/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        '/userpage': (context) => ClockPage(),
        '/home': (context) => LoginScreen(),
        '/adminpage': (context) => AdminPage(),
        '/createusers': (context) => CreateUsersPage(),
        '/listusers': (context) => ListUsersPage(),
      },
      initialRoute: '/home',
    );
  }
}
