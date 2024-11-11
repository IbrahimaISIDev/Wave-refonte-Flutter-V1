// import 'package:flutter/material.dart';
// import 'package:wave_app/presentation/widgets/transfer_form.dart';

// class TransferScreen extends StatelessWidget {
//   const TransferScreen({super.key, String? recipientId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           'Effectuer un transfert',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // En-tête avec solde disponible
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.all(20),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Solde disponible',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '1,234.56 €',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Icon(
//                         Icons.account_balance_wallet,
//                         color: Colors.blue,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
            
//             // Formulaire de transfert amélioré
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Détails du transfert',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const TransferForm(),
                  
//                   // Contacts récents
//                   const SizedBox(height: 30),
//                   const Text(
//                     'Contacts récents',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   SizedBox(
//                     height: 100,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.only(right: 15),
//                           child: Column(
//                             children: [
//                               CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: Colors.blue[100],
//                                 child: Text(
//                                   String.fromCharCode(65 + index),
//                                   style: const TextStyle(
//                                     color: Colors.blue,
//                                     fontSize: 24,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Contact ${index + 1}',
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/presentation/widgets/transfer_form.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_contacts/flutter_contacts.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, String? recipientId});

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  List<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    // Demande de permission pour accéder aux contacts
    bool permissionGranted = await FlutterContacts.requestPermission();

    if (permissionGranted) {
      // Récupérer les contacts si la permission est accordée
      List<Contact> contacts = await FlutterContacts.getContacts(withThumbnail: true);
      setState(() {
        _contacts = contacts;
      });
    } else {
      // Gérer le refus de permission
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission non accordée pour accéder aux contacts.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lecture du bloc d'authentification
    final authBloc = context.read<AuthBloc>();

    return BlocProvider(
      create: (context) => TransferBloc(
        context.read<TransferRepository>(),
        authBloc,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Effectuer un transfert',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solde disponible',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1,234.56 €',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails du transfert',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TransferForm(),
                    const SizedBox(height: 30),
                    const Text(
                      'Contacts récents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 100,
                      child: _contacts == null
                          ? const Center(child: CircularProgressIndicator())
                          : _contacts!.isEmpty
                              ? const Center(child: Text('Aucun contact disponible'))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _contacts?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final contact = _contacts![index];
                                    return Container(
                                      margin: const EdgeInsets.only(right: 15),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.blue[100],
                                            child: Text(
                                              contact.displayName.substring(0, 1),
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            contact.displayName,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 
// import 'package:flutter/material.dart';
// import 'package:flutter_contact/flutter_contact.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wave_app/data/models/contact_model.dart';
// import 'package:wave_app/presentation/screens/transfer/contact_picker_screen.dart';

// class TransferScreen extends StatefulWidget {
//   const TransferScreen({super.key});

//   @override
//   State<TransferScreen> createState() => _TransferScreenState();
// }

// class _TransferScreenState extends State<TransferScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _formKey = GlobalKey<FormState>();
//   final _recipientController = TextEditingController();
//   final _amountController = TextEditingController();
//   DateTime? _scheduledDate;
//   TimeOfDay? _scheduledTime;
//   String _selectedFrequency = 'once';
//   List<Contact> _contacts = []; // To store contacts

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _requestContactsPermission();
//   }

//   Future<void> _requestContactsPermission() async {
//     if (await Permission.contacts.request().isGranted) {
//       _loadContacts();
//     }
//   }

//   Future<void> _loadContacts() async {
//     // Use flutter_contact to load contacts
//     final contacts = await FlutterContact.getContacts();
//     setState(() {
//       _contacts = contacts;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           'Transfert d\'argent',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Solde disponible
//           _buildBalanceCard(),
          
//           // Onglets
//           TabBar(
//             controller: _tabController,
//             tabs: const [
//               Tab(text: 'Simple'),
//               Tab(text: 'Multiple'),
//               Tab(text: 'Planifié'),
//             ],
//             labelColor: Colors.blue,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Colors.blue,
//           ),
          
//           // Contenu des onglets
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildSimpleTransferTab(),
//                 _buildMultipleTransferTab(),
//                 _buildScheduledTransferTab(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBalanceCard() {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Solde disponible',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '1,234.56 €',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Icon(
//                 Icons.account_balance_wallet,
//                 color: Colors.blue,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSimpleTransferTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             // Choix du destinataire
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildOptionButton(
//                     icon: Icons.contact_phone,
//                     text: 'Sélectionner un contact',
//                     onTap: _showContactPicker,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _buildOptionButton(
//                     icon: Icons.dialpad,
//                     text: 'Saisir un numéro',
//                     onTap: () {
//                       // Afficher le champ de saisie
//                       setState(() {
//                         _recipientController.clear();
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
            
//             // Champ du destinataire
//             TextFormField(
//               controller: _recipientController,
//               decoration: InputDecoration(
//                 labelText: 'Numéro du bénéficiaire',
//                 prefixIcon: const Icon(Icons.phone),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               keyboardType: TextInputType.phone,
//               validator: _validatePhoneNumber,
//             ),
//             const SizedBox(height: 16),
            
//             // Champ du montant
//             TextFormField(
//               controller: _amountController,
//               decoration: InputDecoration(
//                 labelText: 'Montant',
//                 prefixIcon: const Icon(Icons.euro),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//               validator: _validateAmount,
//             ),
//             const SizedBox(height: 24),
            
//             // Bouton de transfert
//             ElevatedButton(
//               onPressed: _handleSimpleTransfer,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text('Effectuer le transfert'),
//             ),
            
//             // Liste des dernières transactions
//             const SizedBox(height: 32),
//             const Text(
//               'Dernières transactions',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildRecentTransactionsList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _showContactPicker() async {
//     // This is where you'll select contacts
//     final contact = await showDialog<Contact>(
//       context: context,
//       builder: (context) => ContactPickerDialog(contacts: _contacts),
//     );
    
//     if (contact != null) {
//       setState(() {
//         _recipientController.text = contact.displayName ?? '';
//       });
//     }
//   }

//   // Add other functions as needed...

//   Widget _buildOptionButton({
//     required IconData icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Column(
//             children: [
//               Icon(icon, color: Colors.blue, size: 32),
//               const SizedBox(height: 8),
//               Text(
//                 text,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   // Phone number validation
//   String? _validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer un numéro de téléphone';
//     }
//     // Add a simple regex for validating phone number format
//     final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
//     if (!phoneRegExp.hasMatch(value)) {
//       return 'Numéro de téléphone invalide';
//     }
//     return null;
//   }

//   // Amount validation
//   String? _validateAmount(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer un montant';
//     }
//     final amount = double.tryParse(value);
//     if (amount == null || amount <= 0) {
//       return 'Le montant doit être supérieur à zéro';
//     }
//     return null;
//   }
// }
