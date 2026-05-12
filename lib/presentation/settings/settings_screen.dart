import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tagly/data/settings_repository.dart';
import 'package:tagly/presentation/settings/analytics_toggle.dart';
import 'package:tagly/presentation/utils/tagly_icon.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.repository, super.key});

  final SettingsRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: repository,
        builder: (context, _) {
          return ListView(
            children: [
              SwitchListTile.adaptive(
                isThreeLine: true,
                title: const Text('Nearby Sharing'),
                subtitle: const Text(
                  "Broadcast the tag you're viewing to nearby Tagly users",
                ),
                value: repository.shouldAlwaysBroadcast,
                onChanged: repository.setShouldAlwaysBroadcast,
              ),
              AnalyticsToggle(repository: repository),
              const Divider(),
              ListTile(
                title: const Text('Clear Cache...'),
                subtitle: const Text(
                  '''Free up the storage used by sheet music and learning tracks.''',
                ),

                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _clearCache(context),
              ),
              const Divider(),
              AboutListTile(
                applicationName: repository.packageInfo.appName,
                applicationVersion: repository.packageInfo.version,
                applicationIcon: const TaglyIcon(),
                applicationLegalese:
                    'Copyright © ${DateTime.now().year} Peter Bryant',
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _clearCache(BuildContext context) async {
    final confirmResult = await showOkCancelAlertDialog(
      context: context,
      title: 'Are you sure?',
      message:
          '''Any sheet music and learning tracks stored offline will not be available until you view them again.''',
    );

    if (!context.mounted) return;

    if (confirmResult != .ok) return;

    await repository.clearCache();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared')),
    );
  }
}
