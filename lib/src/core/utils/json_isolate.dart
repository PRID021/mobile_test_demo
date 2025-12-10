import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_test_demo/src/data/models/contact_model.dart';
import 'package:mobile_test_demo/src/data/models/user_credential_model.dart';

UserCredentialModel _parse(String body) {
  return UserCredentialModel.fromJson(jsonDecode(body));
}

Future<UserCredentialModel> parseCredentialInBackground(String body) async {
  return compute(_parse, body);
}


Future<List<ContactModel>> parseContactsInBackground(String jsonString) async {
  return compute(_parseContacts, jsonString);
}

// Actual parsing logic
List<ContactModel> _parseContacts(String jsonString) {
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => ContactModel.fromJson(e)).toList();
}