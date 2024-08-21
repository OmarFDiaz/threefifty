import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 50.0, color: Colors.blue[900]),
              const SizedBox(height: 32.0),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login logic
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login logic
                  Navigator.pushNamed(context, '/adminpage');
                },
                child: const Text('Admin Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login logic
                  Navigator.pushNamed(context, '/userpage');
                },
                child: const Text('UserPage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
