import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Add extends StatefulWidget {
  const Add({Key? key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  var name = TextEditingController();
  var url = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 200,
            color: Colors.white,
            child: TextFormField(
                controller: name,
                style: const TextStyle(color: Colors.black, fontSize: 20),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 12),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )))),
          ),
          const Spacer(),
          Container(
            width: 200,
            color: Colors.black,
            child: TextFormField(
              controller: url,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {

                // Check if both name and url are not empty
                if (name.text.isNotEmpty && url.text.isNotEmpty) {
                  addData(name.text, url.text);
                  Navigator.pop(context,true);
                } else {
                  // Display an error or prompt the user to fill in both fields
                  print('Please fill in both name and url');
                }
              },
              child: const Text('add')),
          const Spacer()
        ],
      ),
    );
  }

  Future<void> addData(String name, String url) async {
    Map<String, dynamic> dataToSend = {
      'name': name,
      'url': url,
    };

    final response = await http.post(
      Uri.parse("http://192.168.1.69:8000/api/projects"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataToSend),
    );

    if (response.statusCode == 201) {
        print('Data added successfully');

      // You may want to fetch users again after adding new data
    } else {
      print('Failed to add data. Error: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }
}
