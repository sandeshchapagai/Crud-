import 'dart:convert';
import 'package:api_post/add.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
            IconButton(onPressed: (){
              fetchUsers();
              }, icon: const Icon(Icons.refresh_outlined))
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
          if(result==true){
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
                color: Colors.grey,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(id.toString()),
                        Text(name),
                        Text(url)
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
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
                                )
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  addData(name1.toString(), url1.toString());
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  color: Colors.green,
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("okay"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
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
    const url = 'http://192.168.1.69:8000/api/projects';
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
  Future<void> addData(String name1, String url1) async {
    Map<String, dynamic> dataToSend = {
      'name': name1,
      'url': url1,
    };

    final response = await http.post(
      Uri.parse("http://192.168.1.69:8000/api/projects"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataToSend),
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('Data added successfully');
      }
      // You may want to fetch users again after adding new data
    } else {
      if (kDebugMode) {
        print('Failed to add data. Error: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response: ${response.body}');
      }
    }
  }
}
