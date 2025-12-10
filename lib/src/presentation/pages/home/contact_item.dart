import 'package:flutter/material.dart';
import 'package:mobile_test_demo/src/domain/entities/contact.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const ContactItem({
    super.key,
    required this.contact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              child: Text(
                contact.name.isNotEmpty ? contact.name[0] : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),

            // Contact info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Phone
            Text(
              contact.phone,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
