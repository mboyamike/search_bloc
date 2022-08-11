import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:river/cubit/search_cubit.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(contacts: contactsList),
      child: const Scaffold(
        appBar: MainAppBar(),
        body: Body(),
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Sample Search App'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SearchBar(),
            pinned: true,
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state.filteredContacts.isEmpty) {
                return SliverFillRemaining(
                  child: NoContacts(query: state.query),
                );
              }
              return ContactsSliverList(contacts: state.filteredContacts);
            },
          ),
        ],
      ),
    );
  }
}

class NoContacts extends StatelessWidget {
  const NoContacts({Key? key, this.query = ''}) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('No contact matching $query'));
  }
}

class ContactsSliverList extends StatelessWidget {
  const ContactsSliverList({
    Key? key,
    required this.contacts,
  }) : super(key: key);

  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((_, index) {
        final contact = contacts[index];
        return ListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phoneNumber),
        );
      }, childCount: contacts.length),
    );
  }
}

class SearchBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SizedBox(
        width: 300,
        child: TextFormField(
          onChanged: (query) => context.read<SearchCubit>().query(query),
        ),
      ),
    );
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class Contact {
  Contact({required this.name, required this.phoneNumber});

  final String name;
  final String phoneNumber;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contact &&
        other.name == name &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode => name.hashCode ^ phoneNumber.hashCode;
}

final contactsList = List.generate(
  10000,
  (index) => Contact(
    name: 'Person $index',
    phoneNumber: '${index * Random().nextInt(5000)}',
  ),
);
