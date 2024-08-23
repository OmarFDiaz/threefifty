import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/widgets/AdminPage/admin_page.dart';
import 'package:myapp/widgets/AdminPage/create_users_page.dart';
import 'package:myapp/widgets/AdminPage/list_users_page.dart';
import 'package:myapp/widgets/UserPage/user_page.dart';
import 'package:myapp/widgets/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.data == null) {
              return LoginScreen();
            }

            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  Map<String, dynamic>? data = snapshot.data!.data();
                  if (data!['role'] == 'admin') {
                    return AdminPage();
                  } else {
                    return ClockPage();
                  }
                }
                return CircularProgressIndicator();
              },
            );
          }),
      routes: {
        '/userpage': (context) => ClockPage(),
        // '/home': (context) => LoginScreen(),
        '/adminpage': (context) => AdminPage(),
        '/createusers': (context) => CreateUsersPage(),
        '/listusers': (context) => ListUsersPage(),
        '/login': (context) => LoginScreen(),
      }
    );
  }
}
