import 'package:flutter/material.dart';

class ListUsersPage extends StatelessWidget {
  ListUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: Center(
        child: Text('Esta es la lista de usuarios'),
      ),
    );
  }
}
