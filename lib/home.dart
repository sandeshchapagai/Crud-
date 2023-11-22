import 'dart:convert';
import 'package:api_post/add.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'logic.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var name1 = TextEditingController();
  var url1 = TextEditingController();

  List<dynamic> users = [];
  String? name;
  String? url;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Api crud'),
            IconButton(
                onPressed: () {
                  fetchUsers();
                },
                icon: const Icon(Icons.refresh_outlined))
          ],
        ),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Add()),
          );
          if (result == true) {
            fetchUsers();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: Colors.white54,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final data = users[index];
            final id = data['id'];
            final name = data['name'];
            final url = data['url'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.blueGrey,
                child: Row(
                  children: [
                    Column(
                      children: [Text(id.toString()), Text(name), Text(url)],
                    ),
                    const Spacer(
                      flex: 5,
                    ),
                    IconButton(
                      onPressed: () {
                        deleteData(id);
                        // Navigator.pop(context, true);
                        fetchUsers(); // Refresh API data after editin
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        name1.text = data['name'];
                        url1.text = data['url'];

                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Edit"),
                            content: Column(
                              children: [
                                TextField(
                                  controller: name1,
                                ),
                                TextField(
                                  controller: url1,
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Check if both name and url are not empty
                                    if (name1.text.isNotEmpty &&
                                        url1.text.isNotEmpty) {
                                      upData(name1.text, url1.text,
                                          id); // Use name1.text and url1.text instead of name and url
                                      Navigator.pop(context, true);
                                    } else {
                                      // Display an error or prompt the user to fill in both fields
                                      print('Please fill in both name and url');
                                    }

                                    fetchUsers();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("okay"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void fetchUsers() async {
    const url = 'http://192.168.1.69:9000/api/projects';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['projects']['data'];
    });
    if (kDebugMode) {
      print('Completed');
    }
  }
}
