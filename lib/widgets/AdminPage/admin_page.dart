import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AdminPage extends StatelessWidget {
  AdminPage({super.key});

  void logout() async {
    final user = await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 100, 0, 10),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/listusers');
                },
                child: Text('Ver Usuarios')),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/createusers');
                },
                child: Text('Crear Usuario')),
          ),
        ],
      )),
    );
  }
}
