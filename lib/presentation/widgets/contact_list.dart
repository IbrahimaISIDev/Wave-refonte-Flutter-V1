import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

// class ContactList extends StatefulWidget {
//   @override
//   _ContactListState createState() => _ContactListState();
// }

// class _ContactListState extends State<ContactList> {
//   List<Contact>? _contacts;

//   @override
//   void initState() {
//     super.initState();
//     _getContacts();
//   }

//   Future<void> _getContacts() async {
//     bool permissionGranted = await FlutterContacts.requestPermission();
//     if (permissionGranted) {
//       List<Contact> contacts = await FlutterContacts.getContacts(withThumbnail: true);
//       setState(() {
//         _contacts = contacts;
//       });
//     } else {
//       setState(() {
//         _contacts = null;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Permission non accordée pour accéder aux contacts.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: _contacts == null
//           ? const Center(child: CircularProgressIndicator())
//           : _contacts!.isEmpty
//               ? const Center(child: Text('Aucun contact disponible'))
//               : ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: _contacts?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     final contact = _contacts![index];
//                     return Container(
//                       margin: const EdgeInsets.only(right: 15),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Colors.blue[100],
//                             child: Text(
//                               contact.displayName.substring(0, 1),
//                               style: const TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 24,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             contact.displayName,
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }


class EnhancedContactList extends StatefulWidget {
  final bool multiSelect;
  final Function(List<Contact>)? onContactsSelected;

  const EnhancedContactList({
    super.key,
    this.multiSelect = false,
    this.onContactsSelected,
  });

  @override
  _EnhancedContactListState createState() => _EnhancedContactListState();
}

class _EnhancedContactListState extends State<EnhancedContactList> {
  List<Contact> contacts = [];
  Set<Contact> selectedContacts = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final fetchedContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
      );
      setState(() {
        contacts = fetchedContacts;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission refusée pour accéder aux contacts'),
        ),
      );
    }
  }

  void _toggleContact(Contact contact) {
    setState(() {
      if (widget.multiSelect) {
        if (selectedContacts.contains(contact)) {
          selectedContacts.remove(contact);
        } else {
          selectedContacts.add(contact);
        }
      } else {
        selectedContacts = {contact};
      }
    });

    widget.onContactsSelected?.call(selectedContacts.toList());
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 400,
      child: contacts.isEmpty
          ? const Center(
              child: Text(
                'Aucun contact disponible',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final isSelected = selectedContacts.contains(contact);

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        contact.displayName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : 'Pas de numéro',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: widget.multiSelect
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleContact(contact),
                          )
                        : Icon(
                            isSelected ? Icons.check_circle : Icons.circle_outlined,
                            color: isSelected ? Colors.blue : Colors.grey,
                          ),
                    onTap: () => _toggleContact(contact),
                  ),
                );
              },
            ),
    );
  }
}
