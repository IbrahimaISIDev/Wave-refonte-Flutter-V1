// lib/data/models/contact_model.dart
import 'package:wave_app/data/models/contact_model.dart';
// lib/data/bloc/contact_state.dart

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<ContactModel> contacts;

  ContactLoaded(this.contacts);
}

class ContactAdded extends ContactState {
  final ContactModel contact;

  ContactAdded(this.contact);
}

class ContactUpdated extends ContactState {
  final ContactModel contact;

  ContactUpdated(this.contact);
}

class ContactDeleted extends ContactState {
  final int id;

  ContactDeleted(this.id);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);
}


