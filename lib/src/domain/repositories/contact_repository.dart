import 'package:mobile_test_demo/src/domain/entities/contact.dart';


abstract class ContactRepository {
  /// Fetch contacts
  Future<List<Contact>> fetchContacts();
}
