// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
// import 'package:wave_app/bloc/transfer/transfer_event.dart';
// import 'package:wave_app/bloc/transfer/transfer_state.dart';
// import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
// import 'package:wave_app/services/notification_service.dart';
// import 'package:wave_app/utils/styles.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

// class ScheduledTransferForm extends StatefulWidget {
//   const ScheduledTransferForm({super.key});

//   @override
//   _ScheduledTransferFormState createState() => _ScheduledTransferFormState();
// }

// class _ScheduledTransferFormState extends State<ScheduledTransferForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _recipientController = TextEditingController();
//   final _amountController = TextEditingController();
//   DateTime? _selectedDate;
//   String? _selectedFrequency;
//   TimeOfDay? _selectedTime;
//   bool _isProcessing = false;

//   String? _validateRecipient(String? value) {
//     if (value?.isEmpty ?? true) {
//       return 'Numéro requis';
//     }
//     return null;
//   }

//   String? _validateAmount(String? value) {
//     if (value?.isEmpty ?? true) {
//       return 'Montant requis';
//     }
//     final amount = double.tryParse(value ?? '');
//     if (amount == null || amount <= 0) {
//       return 'Montant invalide';
//     }
//     return null;
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 1)),
//       firstDate: DateTime.now().add(const Duration(days: 1)),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   void _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState?.validate() ?? false) {
//       final recipientPhone = _recipientController.text;
//       final amount = double.tryParse(_amountController.text) ?? 0.0;
//       final startDate = _selectedDate;
//       final frequency = _selectedFrequency;
//       final executionTime = _selectedTime?.format(context);

//       if (startDate != null && frequency != null && executionTime != null) {
//         final endDate = startDate.add(const Duration(days: 365));
//         context.read<TransferBloc>().add(
//               ScheduleTransferEvent(
//                 recipientPhone: recipientPhone,
//                 amount: amount,
//                 startDate: startDate,
//                 endDate: endDate,
//                 frequency: frequency,
//                 executionTime: executionTime,
//               ),
//             );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<TransferBloc, TransferState>(
//       listener: (context, state) {
//         if (state is TransferSuccess) {
//           setState(() => _isProcessing = false);
//           NotificationService.showNotification(
//             context,
//             message: state.message,
//             type: NotificationType.success,
//           );
//           _recipientController.clear();
//           _amountController.clear();
//           _selectedDate = null;
//           _selectedFrequency = null;
//           _selectedTime = null;
//         } else if (state is TransferFailure) {
//           setState(() => _isProcessing = false);
//           NotificationService.showNotification(
//             context,
//             message: state.error,
//             type: NotificationType.error,
//           );
//         } else if (state is TransferLoading) {
//           setState(() => _isProcessing = true);
//         }
//       },
//       builder: (context, state) {
//         return Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _recipientController,
//                 decoration: TransferFormStyles.getInputDecoration(
//                   labelText: 'Numéro du bénéficiaire',
//                   icon: Icons.person,
//                 ),
//                 validator: _validateRecipient,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: TransferFormStyles.getInputDecoration(
//                   labelText: 'Montant',
//                   icon: Icons.attach_money,
//                   hintText: '0.00 FCFA',
//                 ),
//                 validator: _validateAmount,
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () => _selectDate(context),
//                 child: InputDecorator(
//                   decoration: TransferFormStyles.getInputDecoration(
//                     labelText: 'Date de début',
//                     icon: Icons.calendar_today,
//                   ),
//                   child: Text(_selectedDate?.toString().split(' ')[0] ?? 'Sélectionner une date'),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: _selectedFrequency,
//                 decoration: TransferFormStyles.getInputDecoration(
//                   labelText: 'Fréquence',
//                   icon: Icons.repeat,
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'daily', child: Text('Quotidien')),
//                   DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
//                   DropdownMenuItem(value: 'monthly', child: Text('Mensuel')),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedFrequency = value;
//                   });
//                 },
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Fréquence requise' : null,
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () => _selectTime(context),
//                 child: InputDecorator(
//                   decoration: TransferFormStyles.getInputDecoration(
//                     labelText: 'Heure d\'exécution',
//                     icon: Icons.access_time,
//                   ),
//                   child: Text(_selectedTime?.format(context) ?? 'Sélectionner une heure'),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               LoadingButton(
//                 isLoading: _isProcessing,
//                 onPressed: _submitForm,
//                 text: 'Programmer le transfert',
//                 style: TransferFormStyles.primaryButtonStyle,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
import 'package:wave_app/services/notification_service.dart';
import 'package:wave_app/utils/styles.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class ScheduledTransferForm extends StatefulWidget {
  const ScheduledTransferForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduledTransferFormState createState() => _ScheduledTransferFormState();
}

class _ScheduledTransferFormState extends State<ScheduledTransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedFrequency;
  TimeOfDay? _selectedTime;
  bool _isProcessing = false;

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String? _validateRecipient(String? value) {
    return (value?.isEmpty ?? true) ? 'Numéro requis' : null;
  }

  String? _validateAmount(String? value) {
    if (value?.isEmpty ?? true) return 'Montant requis';
    final amount = double.tryParse(value ?? '');
    if (amount == null || amount <= 0) return 'Montant invalide';
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final recipientPhone = _recipientController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final startDate = _selectedDate;
      final frequency = _selectedFrequency;
      final executionTime = _selectedTime?.format(context);

      if (startDate != null && frequency != null && executionTime != null) {
        final endDate = startDate.add(const Duration(days: 365));
        context.read<TransferBloc>().add(
              ScheduleTransferEvent(
                recipientPhone: recipientPhone,
                amount: amount,
                startDate: startDate,
                endDate: endDate,
                frequency: frequency,
                executionTime: executionTime,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferBloc, TransferState>(
      listener: (context, state) {
        if (state is TransferSuccess) {
          setState(() => _isProcessing = false);
          NotificationService.showNotification(
            context,
            message: state.message,
            type: NotificationType.success,
          );
          _recipientController.clear();
          _amountController.clear();
          _selectedDate = null;
          _selectedFrequency = null;
          _selectedTime = null;
        } else if (state is TransferFailure) {
          setState(() => _isProcessing = false);
          NotificationService.showNotification(
            context,
            message: state.error,
            type: NotificationType.error,
          );
        } else if (state is TransferLoading) {
          setState(() => _isProcessing = true);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _recipientController,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Numéro du bénéficiaire',
                  icon: Icons.person,
                ),
                validator: _validateRecipient,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Montant',
                  icon: Icons.attach_money,
                  hintText: '0.00 FCFA',
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: TransferFormStyles.getInputDecoration(
                    labelText: 'Date de début',
                    icon: Icons.calendar_today,
                  ),
                  child: Text(
                    _selectedDate?.toString().split(' ')[0] ?? 'Sélectionner une date',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Fréquence',
                  icon: Icons.repeat,
                ),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Quotidien')),
                  DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
                  DropdownMenuItem(value: 'monthly', child: Text('Mensuel')),
                ],
                onChanged: (value) => setState(() => _selectedFrequency = value),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Fréquence requise' : null,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: TransferFormStyles.getInputDecoration(
                    labelText: 'Heure d\'exécution',
                    icon: Icons.access_time,
                  ),
                  child: Text(
                    _selectedTime?.format(context) ?? 'Sélectionner une heure',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              LoadingButton(
                isLoading: _isProcessing,
                onPressed: _submitForm,
                text: 'Programmer le transfert',
                style: TransferFormStyles.primaryButtonStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}
