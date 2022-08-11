import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required List<Contact> contacts})
      : super(SearchState(contacts: contacts));

  void query(String query) {
    emit(state.copyWith(query: query));
  }
}
