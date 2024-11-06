abstract class ContactEvent {}

class LoadContactsEvent extends ContactEvent {}

class CreateContactEvent extends ContactEvent {
  final String name;
  final String phone;

  CreateContactEvent({
    required this.name,
    required this.phone,
  });
}

class UpdateContactEvent extends ContactEvent {
  final int id;
  final String name;
  final String phone;

  UpdateContactEvent({
    required this.id,
    required this.name,
    required this.phone,
  });
}

class DeleteContactEvent extends ContactEvent {
  final int id;

  DeleteContactEvent({required this.id});
}