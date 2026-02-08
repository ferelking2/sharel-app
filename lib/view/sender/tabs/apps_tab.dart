import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/apps_viewmodel.dart';
import '../../../viewmodel/selection_viewmodel.dart';
import '../../../model/selected_item.dart';

class AppsTab extends StatefulWidget {
  const AppsTab({super.key});

  @override
  State<AppsTab> createState() => _AppsTabState();
}

class _AppsTabState extends State<AppsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!Platform.isAndroid) {
      return const Center(
        child: Text('Liste des applications non disponible sur cette plateforme'),
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        final appsState = ref.watch(appsProvider);
        final selection = ref.watch(selectionProvider);
        final selectionNotifier = ref.read(selectionProvider.notifier);

        if (appsState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (appsState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(appsState.error!),
                ElevatedButton(
                  onPressed: () => ref.read(appsProvider.notifier).loadApps(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        final apps = appsState.apps;

        return ListView.builder(
          key: const PageStorageKey('apps'),
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            final selectedItem = SelectedItem.app(
              packageName: app.packageName,
              name: app.name,
              iconPath: null, // TODO: handle icon
            );
            final isSelected = selection.contains(selectedItem);

            return ListTile(
              leading: Image.memory(app.icon, width: 40, height: 40),
              title: Text(app.name),
              subtitle: Text(app.packageName),
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