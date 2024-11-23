import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
import 'package:wave_app/services/notification_service.dart';
import 'package:wave_app/utils/styles.dart';
import 'package:intl/intl.dart';

class ScheduledTransferForm extends StatefulWidget {
  const ScheduledTransferForm({super.key});

  @override
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
    if (amount < 500) return 'Le montant minimum est de 500 FCFA';
    return null;
  }

  String? _validateTime(TimeOfDay? time) {
    if (time == null) return 'Heure d\'exécution requise';
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
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

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final recipientPhone = _recipientController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final startDate = _selectedDate;
      final frequency = _selectedFrequency;
      final timeValidation = _validateTime(_selectedTime);

      if (timeValidation != null) {
        NotificationService.showNotification(
          context,
          message: timeValidation,
          type: NotificationType.error,
        );
        return;
      }

      if (startDate != null && frequency != null && _selectedTime != null) {
        final endDate = startDate.add(const Duration(days: 365));
        final formattedTime = formatTimeOfDay(_selectedTime!);

        context.read<TransferBloc>().add(
              ScheduleTransferEvent(
                recipientPhone: recipientPhone,
                amount: amount,
                startDate: startDate,
                endDate: endDate,
                frequency: frequency,
                executionTime: formattedTime,
              ),
            );
      }
    }
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return DateFormat('HH:mm').format(dateTime);
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
          _formKey.currentState?.reset();
          _recipientController.clear();
          _amountController.clear();
          setState(() {
            _selectedDate = null;
            _selectedFrequency = null;
            _selectedTime = null;
          });
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
                  icon: Icons.person, suffixText: '',
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
                  hintText: '500 FCFA minimum', suffixText: '',
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: FormField<DateTime>(
                  validator: (value) => value == null ? 'Date requise' : null,
                  initialValue: _selectedDate,
                  builder: (FormFieldState<DateTime> state) {
                    return InputDecorator(
                      decoration: TransferFormStyles.getInputDecoration(
                        labelText: 'Date de début',
                        icon: Icons.calendar_today,
                        errorText: state.errorText, suffixText: '',
                      ),
                      child: Text(
                        _selectedDate != null
                            ? formatDate(_selectedDate!)
                            : 'Sélectionner une date',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Fréquence',
                  icon: Icons.repeat, suffixText: '',
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
                child: FormField<TimeOfDay>(
                  validator: (value) => _validateTime(value),
                  initialValue: _selectedTime,
                  builder: (FormFieldState<TimeOfDay> state) {
                    return InputDecorator(
                      decoration: TransferFormStyles.getInputDecoration(
                        labelText: 'Heure d\'exécution',
                        icon: Icons.access_time,
                        errorText: state.errorText, suffixText: '',
                      ),
                      child: Text(
                        _selectedTime != null
                            ? formatTimeOfDay(_selectedTime!)
                            : 'Sélectionner une heure',
                      ),
                    );
                  },
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


/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
import 'package:wave_app/services/notification_service.dart';
import 'package:wave_app/utils/styles.dart';
import 'package:intl/intl.dart';

class ScheduledTransferForm extends StatefulWidget {
  const ScheduledTransferForm({super.key});

  @override
  _ScheduledTransferFormState createState() => _ScheduledTransferFormState();
}

class _ScheduledTransferFormState extends State<ScheduledTransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _selectedEndDate;
  String? _selectedFrequency;
  TimeOfDay? _selectedTime;
  bool _isProcessing = false;

  final Map<String, String> _frequencyMap = {
    'Quotidien': 'daily',
    'Hebdomadaire': 'weekly',
    'Mensuel': 'monthly',
  };

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String? _validateRecipient(String? value) {
    if (value?.isEmpty ?? true) return 'Numéro requis';
    if (!RegExp(r'^\d{9}$').hasMatch(value!)) {
      return 'Numéro invalide (9 chiffres requis)';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value?.isEmpty ?? true) return 'Montant requis';
    final amount = double.tryParse(value ?? '');
    if (amount == null || amount <= 0) return 'Montant invalide';
    if (amount < 500) return 'Le montant minimum est de 500 FCFA';
    if (amount > 1000000) return 'Le montant maximum est de 1,000,000 FCFA';
    return null;
  }

  String? _validateDate(DateTime? date) {
    if (date == null) return 'Date requise';
    if (date.isBefore(DateTime.now())) {
      return 'La date doit être future';
    }
    return null;
  }

  String? _validateEndDate(DateTime? endDate) {
    if (endDate == null) return null; // Date de fin optionnelle
    if (_selectedDate == null) return 'Veuillez d\'abord sélectionner une date de début';
    if (endDate.isBefore(_selectedDate!)) {
      return 'La date de fin doit être après la date de début';
    }
    if (endDate.difference(_selectedDate!).inDays > 365) {
      return 'La période ne peut pas dépasser 1 an';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context, bool isEndDate) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isEndDate
          ? (_selectedEndDate ?? _selectedDate ?? currentDate.add(const Duration(days: 1)))
          : (_selectedDate ?? currentDate.add(const Duration(days: 1))),
      firstDate: isEndDate
          ? (_selectedDate ?? currentDate)
          : currentDate,
      lastDate: currentDate.add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
    );

    if (picked != null) {
      setState(() {
        if (isEndDate) {
          _selectedEndDate = picked;
        } else {
          _selectedDate = picked;
          // Reset end date if start date is after it
          if (_selectedEndDate != null && picked.isAfter(_selectedEndDate!)) {
            _selectedEndDate = null;
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'fr_FR').format(date);
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final recipientPhone = _recipientController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      
      // Validation finale
      if (_selectedDate == null) {
        NotificationService.showNotification(
          context,
          message: 'Date de début requise',
          type: NotificationType.error,
        );
        return;
      }

      if (_selectedTime == null) {
        NotificationService.showNotification(
          context,
          message: 'Heure d\'exécution requise',
          type: NotificationType.error,
        );
        return;
      }

      if (_selectedFrequency == null) {
        NotificationService.showNotification(
          context,
          message: 'Fréquence requise',
          type: NotificationType.error,
        );
        return;
      }

      // Utiliser la date de fin fournie ou définir une date par défaut à un an
      final endDate = _selectedEndDate ?? _selectedDate!.add(const Duration(days: 365));

      try {
        context.read<TransferBloc>().add(
          ScheduleTransferEvent(
            recipientPhone: recipientPhone,
            amount: amount,
            startDate: _selectedDate!,
            endDate: endDate,
            frequency: _frequencyMap[_selectedFrequency!] ?? 'daily',
            executionTime: formatTimeOfDay(_selectedTime!),
          ),
        );
      } catch (e) {
        NotificationService.showNotification(
          context,
          message: 'Une erreur est survenue. Veuillez réessayer.',
          type: NotificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocConsumer<TransferBloc, TransferState>(
            listener: (context, state) {
              if (state is TransferSuccess) {
                setState(() => _isProcessing = false);
                NotificationService.showNotification(
                  context,
                  message: state.message,
                  type: NotificationType.success,
                );
                _formKey.currentState?.reset();
                _resetForm();
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _recipientController,
                      decoration: TransferFormStyles.getInputDecoration(
                        labelText: 'Numéro du bénéficiaire',
                        icon: Icons.person,
                        hintText: 'Ex: 123456789', suffixText: '',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 9,
                      validator: _validateRecipient,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: TransferFormStyles.getInputDecoration(
                        labelText: 'Montant',
                        icon: Icons.attach_money,
                        hintText: '500 FCFA minimum',
                        suffixText: 'FCFA',
                      ),
                      validator: _validateAmount,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: FormField<DateTime>(
                        validator: (value) => _validateDate(_selectedDate),
                        initialValue: _selectedDate,
                        builder: (FormFieldState<DateTime> state) {
                          return InputDecorator(
                            decoration: TransferFormStyles.getInputDecoration(
                              labelText: 'Date de début',
                              icon: Icons.calendar_today,
                              errorText: state.errorText, suffixText: '',
                            ),
                            child: Text(
                              _selectedDate != null
                                  ? formatDate(_selectedDate!)
                                  : 'Sélectionner une date',
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: FormField<DateTime>(
                        validator: (value) => _validateEndDate(_selectedEndDate),
                        initialValue: _selectedEndDate,
                        builder: (FormFieldState<DateTime> state) {
                          return InputDecorator(
                            decoration: TransferFormStyles.getInputDecoration(
                              labelText: 'Date de fin (optionnelle)',
                              icon: Icons.calendar_today,
                              errorText: state.errorText, suffixText: '',
                            ),
                            child: Text(
                              _selectedEndDate != null
                                  ? formatDate(_selectedEndDate!)
                                  : 'Sélectionner une date de fin',
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedFrequency,
                      decoration: TransferFormStyles.getInputDecoration(
                        labelText: 'Fréquence',
                        icon: Icons.repeat, suffixText: '',
                      ),
                      items: _frequencyMap.keys.map((String frequency) {
                        return DropdownMenuItem(
                          value: frequency,
                          child: Text(frequency),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedFrequency = value),
                      validator: (value) =>
                          value == null ? 'Fréquence requise' : null,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: FormField<TimeOfDay>(
                        validator: (value) =>
                            _selectedTime == null ? 'Heure d\'exécution requise' : null,
                        initialValue: _selectedTime,
                        builder: (FormFieldState<TimeOfDay> state) {
                          return InputDecorator(
                            decoration: TransferFormStyles.getInputDecoration(
                              labelText: 'Heure d\'exécution',
                              icon: Icons.access_time,
                              errorText: state.errorText, suffixText: '',
                            ),
                            child: Text(
                              _selectedTime != null
                                  ? formatTimeOfDay(_selectedTime!)
                                  : 'Sélectionner une heure',
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    LoadingButton(
                      isLoading: _isProcessing,
                      onPressed: _submitForm,
                      text: 'Programmer le transfert',
                      style: TransferFormStyles.primaryButtonStyle,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    _recipientController.clear();
    _amountController.clear();
    setState(() {
      _selectedDate = null;
      _selectedEndDate = null;
      _selectedFrequency = null;
      _selectedTime = null;
    });
  }
} */