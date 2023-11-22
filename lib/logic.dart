import 'dart:convert';
import 'package:http/http.dart' as http;

void addData(String name, String url) async {
  const apikey = "http://192.168.1.69:9000/api/projects";
  Map<String, dynamic> dataToSend = {
    'name': name,
    'url': url,
  };
  final response = await http.post(
    Uri.parse(apikey),
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

void upData(String name, String url, int id) async {
  String apiEndpoint = "http://192.168.1.69:9000/api/projects/$id";

  Map<String, dynamic> dataToSend = {
    'name': name,
    'url': url,
  };

  final response = await http.put(
    Uri.parse(apiEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(dataToSend),
  );

  if (response.statusCode == 200) {
    print('Data updated successfully');

    // You may want to fetch users again after updating data
  } else {
    print('Failed to update data. Error: ${response.statusCode}');
    print('Response: ${response.body}');
  }
}

void deleteData(int id) async {
  String apiEndpoint = "http://192.168.1.69:9000/api/projects/$id";

  final response = await http.delete(
    Uri.parse(apiEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    print('Data deleted successfully');

    // You may want to fetch users again after deleting data
  } else {
    print('Failed to delete data. Error: ${response.statusCode}');
    print('Response: ${response.body}');
  }
}
