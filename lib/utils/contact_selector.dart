import 'package:flutter/material.dart';
import 'package:wave_app/presentation/widgets/contact_list.dart';

class ContactSelector extends StatelessWidget {
  const ContactSelector({super.key, required Null Function(dynamic List) onSelectedContacts});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sélectionner un contact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: EnhancedContactList(
                onContactsSelected: (contacts) {
                  if (contacts.isNotEmpty) {
                    Navigator.of(context).pop(contacts.first);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}