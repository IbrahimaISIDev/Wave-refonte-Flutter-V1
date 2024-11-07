// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:contacts_service/contacts_service.dart';
// // ignore: depend_on_referenced_packages
// import 'package:permission_handler/permission_handler.dart';

// class ContactScreen extends StatefulWidget {
//   const ContactScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ContactScreenState createState() => _ContactScreenState();
// }

// class _ContactScreenState extends State<ContactScreen> {
//   List<Contact>? _contacts;

//   @override
//   void initState() {
//     super.initState();
//     _getContacts();
//   }

//   // Demande de permission et récupération des contacts
//   Future<void> _getContacts() async {
//     // Demander la permission d'accéder aux contacts
//     PermissionStatus permission = await Permission.contacts.request();

//     if (permission.isGranted) {
//       // Si la permission est accordée, récupérer les contacts
//       Iterable<Contact> contacts = await ContactsService.getContacts();
//       setState(() {
//         _contacts = contacts.toList();
//       });
//     } else {
//       // Gérer le cas où la permission est refusée
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Permission non accordée pour accéder aux contacts.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Contacts'),
//       ),
//       body: _contacts == null
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _contacts?.length ?? 0,
//               itemBuilder: (context, index) {
//                 final contact = _contacts![index];
//                 return ListTile(
//                   title: Text(contact.displayName ?? 'Nom inconnu'),
//                   subtitle: Text(contact.phones?.isNotEmpty ?? false
//                       ? contact.phones!.first.value ?? 'Numéro inconnu'
//                       : 'Pas de numéro'),
//                 );
//               },
//             ),
//     );
//   }
// }
