// // lib/screens/contact_picker_screen.dart
// import 'package:flutter/material.dart';
// import 'package:wave_app/data/models/contact_model.dart';

// class ContactPickerScreen extends StatelessWidget {
//   final List<ContactModel> contacts;

//   const ContactPickerScreen({
//     super.key,
//     required this.contacts,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sélectionner des contacts'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Retourner les contacts sélectionnés
//               Navigator.pop(context, contacts.where((c) => c.selected).toList());
//             },
//             child: const Text(
//               'Valider',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: contacts.length,
//         itemBuilder: (context, index) {
//           final contact = contacts[index];
//           return CheckboxListTile(
//             value: contact.selected,
//             onChanged: (value) {
//               // Mettre à jour la sélection
//               contact.selected = value ?? false;
//             },
//             title: Text(contact.name),
//             subtitle: Text(
//               contact.phone.isNotEmpty ? contact.phone : 'Pas de numéro',
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
