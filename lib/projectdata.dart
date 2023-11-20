import 'package:flutter/material.dart';

class ProjectData extends ChangeNotifier {
  String? _name;
  String? _url;

  String? get name => _name;
  String? get url => _url;

  void updateData(String newName, String newUrl) {
    _name = newName;
    _url = newUrl;
    notifyListeners();
  }
}
