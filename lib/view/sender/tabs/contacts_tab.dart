import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/contacts_viewmodel.dart';
import '../../../viewmodel/selection_viewmodel.dart';
import '../../../model/selected_item.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, ref, child) {
        final contactsState = ref.watch(contactsProvider);
        final selection = ref.watch(selectionProvider);
        final selectionNotifier = ref.read(selectionProvider.notifier);

        if (contactsState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (contactsState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(contactsState.error!),
                ElevatedButton(
                  onPressed: () => ref.read(contactsProvider.notifier).loadContacts(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        final contacts = contactsState.contacts;

        return ListView.builder(
          key: const PageStorageKey('contacts'),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            final selectedItem = SelectedItem.contact(
              id: contact.id,
              name: contact.displayName,
              phone: contact.phones.isNotEmpty ? contact.phones.first.number : '',
            );
            final isSelected = selection.contains(selectedItem);

            return ListTile(
              leading: CircleAvatar(
                child: Text(contact.displayName[0]),
              ),
              title: Text(contact.displayName),
              subtitle: contact.phones.isNotEmpty
                  ? Text(contact.phones.first.number)
                  : null,
              trailing: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  selectionNotifier.toggle(selectedItem);
                },
              ),
              onTap: () {
                selectionNotifier.toggle(selectedItem);
              },
            );
          },
        );
      },
    );
  }
}