import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/widgets/reusable/custom_input.dart';

import 'package:random_password_generator/random_password_generator.dart';

import 'package:cloud_functions/cloud_functions.dart';

class CreateUsersPage extends StatefulWidget {
  CreateUsersPage({super.key});

  @override
  State<CreateUsersPage> createState() => _CreateUsersPageState();
}

class _CreateUsersPageState extends State<CreateUsersPage> {
  final auth = FirebaseAuth.instance;

  bool isLoading = false;

  bool isDone = false;

  bool isError = false;

  String errorMessage = '';

  String successMessage = '';

  String uid = '';

  final password = RandomPasswordGenerator();

  String newpassword = '';

  final TextEditingController nombreController = TextEditingController();

  final TextEditingController correoController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> createUser(
      {required String email,
      required String password,
      required String role,
      required String nombre}) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('auth_create_user_admin');

    try {
      print('Data being Sent to the Function');
      print({
        'email': email,
        'password': password,
        'role': role,
        'nombre': nombre,
      });
      final results = await callable.call(<String, dynamic>{
        'email': email,
        'password': password,
        'role': role,
        'nombre': nombre,
      });
      print(results.data);
      if (results.data == "Missing required parameter") {
        isError = true;
        errorMessage = results.data;
        setState(() {});
        return;
      }

      if (results.data['error'] == "Error creating user") {
        print(results.data['error']);
        isError = true;
        errorMessage = results.data['message'];
        setState(() {});
        return;
      }
      if (results.data['message'] == "User created successfully") {
        // Access the uid if needed
        uid = results.data['uid'];
        successMessage = results.data['message'];

        print('User created with uid: $uid');

        passwordController.text = newpassword;

        isDone = true;
        setState(() {});
      }
      return;
    } catch (e) {
      isError = true;
      errorMessage = "Hubo un error al crear el usuario.";
      setState(() {});
      print(e);
    }
  }

  void submitUser() async {
    print('generating password');

    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading = true;
    setState(() {});

    newpassword = password.randomPassword(
        letters: true,
        numbers: true,
        passwordLength: 10,
        specialChar: true,
        uppercase: true);

    createUser(
        email: correoController.text,
        password: newpassword,
        role: 'user',
        nombre: nombreController.text);
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
          ? isError
              ? Center(
                  child: Column(
                  children: [
                    SizedBox(height: 100),
                    Text('Error'),
                    SizedBox(height: 20),
                    Text(errorMessage, textAlign: TextAlign.center,),
                    SizedBox(height: 20),
                    Text('Puede ser que el correo ya esté en uso'),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back'))
                  ],
                ))
              : Center(
                  child: isDone
                      ? SingleChildScrollView(
                          child: Center(
                              child: Column(
                            children: [
                              Text('Usuario Creado'),
                              SizedBox(height: 20),
                              Text(successMessage),
                              SizedBox(height: 20),
                              Text('Press copy button to copy to clipboard'),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 200,
                                  child: TextField(
                                    enabled: false,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                    ),
                                    obscureText: false,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: passwordController.text));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Password copied to clipboard')));
                                  },
                                  child: Text('Copy')),
                              SizedBox(height: 20),
                              Text('UID: $uid'),
                              SizedBox(height: 20),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Back'))
                            ],
                          )),
                        )
                      : Column(
                          children: [
                            SizedBox(height: 100),
                            Text('Creando el Usuario'),
                            SizedBox(height: 20),
                            CircularProgressIndicator(),
                          ],
                        ))
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
