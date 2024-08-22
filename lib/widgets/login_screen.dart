import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/AdminPage/admin_page.dart';
import 'package:myapp/widgets/UserPage/user_page.dart';
import 'package:myapp/widgets/reusable/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController contraseniaController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
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
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          loading = true;
                          setState(() {});

                          try {
                            final result = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: correoController.text,
                              password: contraseniaController.text,
                            );
                            print(result.user!.uid);
                            try {
                              final data = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(result.user!.uid)
                                  .get();
                              print(data.data()!['role']);

                              if (data.data()!['role'] == 'admin') {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminPage(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClockPage(),
                                  ),
                                  (route) => false,
                                );
                              }
                            } catch (e) {
                              print('error en firestore');
                              print(e);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No se encontró el usuario.');
                            } else if (e.code == 'wrong-password') {
                              print('Contraseña incorrecta.');
                            }
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
            ),
    );
  }
}
