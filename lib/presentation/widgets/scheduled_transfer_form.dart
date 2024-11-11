import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/data/models/transfer_model.dart';

class ScheduledTransferForm extends StatefulWidget {
  const ScheduledTransferForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduledTransferFormState createState() => _ScheduledTransferFormState();
}

class _ScheduledTransferFormState extends State<ScheduledTransferForm> {
  final _formKey = GlobalKey<FormState>();
  late String _recipient;
  late double _amount;
  late TransferSchedule _schedule;

  void _submitScheduledTransfer() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<TransferBloc>().add(ScheduleTransferEvent(_recipient, _amount, _schedule));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Numéro de téléphone du destinataire',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir un numéro de téléphone';
              }
              return null;
            },
            onSaved: (value) => _recipient = value!,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Montant à transférer',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir un montant';
              }
              if (double.tryParse(value) == null) {
                return 'Montant invalide';
              }
              return null;
            },
            onSaved: (value) => _amount = double.parse(value!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Fréquence du transfert (jours)',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir une fréquence';
              }
              if (int.tryParse(value) == null) {
                return 'Fréquence invalide';
              }
              return null;
            },
            onSaved: (value) => _schedule = TransferSchedule(
              nextTransferDate: DateTime.now().add(Duration(days: int.parse(value!))),
              frequency: Duration(days: int.parse(value)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitScheduledTransfer,
            child: const Text('Planifier le transfert'),
          ),
        ],
      ),
    );
  }
}