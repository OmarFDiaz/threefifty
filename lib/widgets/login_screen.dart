import 'package:flutter/material.dart';
import 'package:myapp/widgets/reusable/custom_input.dart';
import 'package:cloud_functions/cloud_functions.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController contraseniaController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

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
              CustomInput(
                controller: correoController,
                label: 'Correo',
                icon: Icons.email,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }

                  if (!value.contains('@')) {
                    return 'El correo no es válido';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomInput(
                controller: contraseniaController,
                label: 'Contraseña',
                icon: Icons.lock,
                maxLength: 30,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  print('Login button pressed');

                  HttpsCallable callable = FirebaseFunctions.instance
                      .httpsCallable('get_users_custom_token');

                  try {
                    print('Data being Sent to the Function');
                    print({
                      'email': correoController.text,
                      'password': contraseniaController.text,
                    });

                    final result = await callable.call(<String, dynamic>{
                      'email': correoController.text,
                      'password': contraseniaController.text,
                    });

                    print(result.data);
                  } catch (e) {
                    print('Errrrooooor');
                    print(e);
                  }
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/adminpage');
                },
                child: const Text('Admin Page'),
              ),
              ElevatedButton(
                onPressed: () {
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
