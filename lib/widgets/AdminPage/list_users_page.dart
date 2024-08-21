import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart';

class ListUsersPage extends StatefulWidget {
  ListUsersPage({super.key});

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('get_users');

  List users = [];

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
      });
    }
  }

  void refresh() async {
    await getUsers();
  }

  void deleteUsers() async {
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
      body: Center(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];

              return ListTile(
                title: Text(user['displayName']),
                subtitle: Text(user['email']),
                trailing:
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              );
            },
            itemCount: users.length),
      ),
    );
  }
}
