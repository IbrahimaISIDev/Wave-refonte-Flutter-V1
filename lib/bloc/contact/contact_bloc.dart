import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/data/models/contact_model.dart';
import 'package:wave_app/bloc/contact/contact_state.dart';
import 'package:wave_app/bloc/contact/contact_event.dart';
import 'package:wave_app/data/repositories/contact_repository.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _contactRepository;

  ContactBloc(this._contactRepository) : super(ContactInitial()) {
    on<LoadContactsEvent>(_handleLoadContacts);
    on<CreateContactEvent>(_handleCreateContact);
    on<UpdateContactEvent>(_handleUpdateContact);
    on<DeleteContactEvent>(_handleDeleteContact);
  }

  Future<void> _handleLoadContacts(
      LoadContactsEvent event,
      Emitter<ContactState> emit,
      ) async {
    emit(ContactLoading());
    try {
      final contacts = await _contactRepository.getContacts();
      emit(ContactLoaded(contacts));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> _handleCreateContact(
      CreateContactEvent event,
      Emitter<ContactState> emit,
      ) async {
    try {
      final contact = await _contactRepository.createContact(
        event.name,
        event.phone,
      );
      emit(ContactAdded(contact));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> _handleUpdateContact(
      UpdateContactEvent event,
      Emitter<ContactState> emit,
      ) async {
    try {
      final contact = await _contactRepository.updateContact(
        event.id,
        event.name,
        event.phone,
      );
      emit(ContactUpdated(contact));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  Future<void> _handleDeleteContact(
      DeleteContactEvent event,
      Emitter<ContactState> emit,
      ) async {
    try {
      await _contactRepository.deleteContact(event.id);
      emit(ContactDeleted(event.id));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }
}
