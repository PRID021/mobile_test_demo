import 'package:dio/dio.dart';
import 'package:mobile_test_demo/src/core/network/auth_dio_client.dart';
import 'package:mobile_test_demo/src/core/utils/json_isolate.dart';
import 'package:mobile_test_demo/src/data/models/contact_model.dart';

abstract class ContactRemoteDataSource {
  Future<List<ContactModel>> getContacts();
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final AuthDioClient client;

  ContactRemoteDataSourceImpl(this.client);

  @override
  Future<List<ContactModel>> getContacts() async {
    try {
      final response = await client.dio.get('/contacts');
      return parseContactsInBackground(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch contacts: ${e.message}');
    }
  }
}
