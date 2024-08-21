import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ListUsersPage extends StatefulWidget {
  ListUsersPage({super.key});

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('get_users');

  List users = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    setState(() {
      users = [];
    });
    final results = await callable.call();
    print(results.data);
    if (results.data != null) {
      List<dynamic> data = results.data as List<dynamic>;
      setState(() {
        users = data
            .map((userData) => {
                  'uid': userData['uid'],
                  'displayName': userData['displayName'],
                  'email': userData['email'],
                })
            .toList();
        isLoading = false;
      });
    }
  }

  void refresh() async {
    isLoading = true;
    setState(() {});
    await getUsers();
  }

  void deleteUser({required String uid}) async {
    isLoading = true;
    setState(() {});
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('delete_user');
    final response = await callable.call(<String, dynamic>{
      'uid': uid,
    });

    print(response.data);

    await getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        actions: [
          IconButton(onPressed: refresh, icon: Icon(Icons.refresh)),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(child: Text('No hay usuarios'))
              : Center(
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final user = users[index];
                        print(user);

                        return ListTile(
                          title: Text(user['displayName']),
                          subtitle: Text(user['email']),
                          trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Eliminar Usuario'),
                                        content: Text(
                                            '¿Estás seguro de que deseas eliminar este usuario?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                deleteUser(uid: user['uid']);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Delete',
                                                selectionColor: Colors.red,
                                              ))
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.delete)),
                        );
                      },
                      itemCount: users.length),
                ),
    );
  }
}
