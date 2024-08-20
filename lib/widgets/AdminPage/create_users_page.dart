import 'package:flutter/material.dart';
import 'package:myapp/widgets/reusable/custom_input.dart';

import 'package:random_password_generator/random_password_generator.dart';

class CreateUsersPage extends StatefulWidget {
  CreateUsersPage({super.key});

  @override
  State<CreateUsersPage> createState() => _CreateUsersPageState();
}

class _CreateUsersPageState extends State<CreateUsersPage> {
  bool isLoading = false;

  bool isDone = false;

  final password = RandomPasswordGenerator();

  String newpassword = '';

  final TextEditingController nombreController = TextEditingController();

  final TextEditingController correoController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void submitUser() {
    print('generating password');

    if (!formKey.currentState!.validate()) {
      return;
    }
    newpassword = password.randomPassword(
        letters: true,
        numbers: true,
        passwordLength: 10,
        specialChar: true,
        uppercase: true);
    final data = {
      'nombre': nombreController.text,
      'correo': correoController.text,
      'contrasenia': newpassword,
      'role': 'user'
    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 100),
                      SizedBox(
                        width: 350,
                        child: CustomInput(
                          label: 'Nombre',
                          controller: nombreController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El nombre es obligatorio';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: CustomInput(
                          controller: correoController,
                          label: 'Correo',
                          icon: Icons.email,
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El correo es obligatorio';
                            }

                            if (!value.contains('@')) {
                              return 'El correo no es válido';
                            }

                            return null;
                          },
                        ),
                      ),
                      ElevatedButton(
                          onPressed: submitUser, child: Text('Create User'))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
