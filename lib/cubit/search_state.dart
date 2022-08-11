part of 'search_cubit.dart';

class SearchState {
  SearchState({
    required this.contacts,
    this.query = '',
  });

  final List<Contact> contacts;
  final String query;
  
  List<Contact> get filteredContacts => query.trim().isEmpty
      ? contacts
      : contacts
          .where(
            (contact) =>
                contact.name
                    .toLowerCase()
                    .contains(query.trim().toLowerCase()) ||
                contact.phoneNumber
                    .toLowerCase()
                    .contains(query.trim().toLowerCase()),
          )
          .toList();

  SearchState copyWith({
    List<Contact>? contacts,
    String? query,
  }) {
    return SearchState(
      contacts: contacts ?? this.contacts,
      query: query ?? this.query,
    );
  }
}
