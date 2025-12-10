import 'package:mobile_test_demo/src/data/datasources/contact_remote_data_source.dart';
import 'package:mobile_test_demo/src/domain/entities/contact.dart';
import 'package:mobile_test_demo/src/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource remoteDataSource;

  ContactRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Contact>> fetchContacts() async {
    try {
      // Remote data source already parses JSON in background isolate
      return await remoteDataSource.getContacts();
    } catch (e) {
      // Optional: map to domain-specific exceptions
      rethrow;
    }
  }
}
