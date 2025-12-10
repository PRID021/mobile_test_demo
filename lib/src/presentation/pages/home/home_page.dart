import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_test_demo/src/domain/repositories/contact_repository.dart';
import 'package:mobile_test_demo/src/presentation/bloc/app/app_bloc.dart';
import 'package:mobile_test_demo/src/presentation/bloc/home/home_bloc.dart';
import 'package:mobile_test_demo/src/presentation/bloc/home/home_event.dart';
import 'package:mobile_test_demo/src/presentation/bloc/home/home_state.dart';
import 'package:mobile_test_demo/src/presentation/pages/home/contact_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        contactRepository: context.read<ContactRepository>(),
      )..add(
          LoadContacts(),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                final appBloc = context.read<AppBloc>();
                appBloc.add(LoggedOut());
              },
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is HomeLoaded) {
              final contacts = state.contacts;
              if (contacts.isEmpty) {
                return const Center(child: Text('No contacts found.'));
              }
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final contact = contacts[index];
                        return Column(
                          children: [
                            ContactItem(
                              contact: contact,
                              onTap: () =>
                                  context.push('/home/contact/${contact.id}'),
                            ),
                            if (index < contacts.length - 1)
                              const Divider(height: 1, thickness: 1),
                          ],
                        );
                      },
                      childCount: contacts.length,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
