import 'package:flutter/material.dart';
import 'package:wave_app/presentation/widgets/transfer_form.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // En-tête avec solde disponible
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
            
            // Formulaire de transfert amélioré
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
                  
                  // Contacts récents
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.blue[100],
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Contact ${index + 1}',
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
    );
  }
}

/* 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';
import 'package:wave_app/bloc/auth/auth_bloc.dart';
import 'package:wave_app/presentation/widgets/transfer_form.dart';
// ignore: depend_on_referenced_packages
import 'package:contacts_service/contacts_service.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  List<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  // Demander la permission et récupérer les contacts
  Future<void> _getContacts() async {
    // Demander la permission d'accéder aux contacts
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isGranted) {
      // Si l'autorisation est accordée, récupérer les contacts
      Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts.toList();
      });
    } else {
      setState(() {
      });
      // Gérer le cas où la permission n'est pas accordée
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission non accordée pour accéder aux contacts.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer l'instance de AuthBloc depuis le contexte parent
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
              // En-tête avec solde disponible
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
              
              // Formulaire de transfert amélioré
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
                    
                    // Contacts récents
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
                                              contact.initials(),
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            contact.displayName ?? 'Contact ${index + 1}',
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
 */