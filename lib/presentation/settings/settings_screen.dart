import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tagly/data/settings_repository.dart';
import 'package:tagly/presentation/settings/analytics_toggle.dart';
import 'package:tagly/presentation/utils/tagly_icon.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.repository, super.key});

  final SettingsRepository repository;

  @override
  Widget build(BuildContext context) {
    final info = repository.packageInfo;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: repository,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _AppHeader(
                name: info.appName,
                version: info.version,
              ),
              const SizedBox(height: 16),
              const _SectionHeader('Privacy'),
              _SettingsCard(
                children: [AnalyticsToggle(repository: repository)],
              ),
              const _SectionHeader('Storage'),
              _SettingsCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.delete_sweep_outlined),
                    title: const Text('Clear Cache'),
                    subtitle: const Text(
                      'Free up storage used by sheet music and '
                      'learning tracks.',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _clearCache(context),
                  ),
                ],
              ),
              const _SectionHeader('About'),
              _SettingsCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.flag_outlined),
                    title: const Text('Made in the UK'),
                    subtitle: const Text(
                      'Tagly is an indie app made with ♥ by Peter '
                      'Bryant — a barbershop singer and enthusiast.',
                    ),
                    onTap: () async {
                      await launchUrlString(
                        'https://peterbryantmusic.com',
                        mode: .externalApplication,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.red,
                    ),
                    title: const Text('Tag data from barbershoptags.com'),
                    subtitle: const Text(
                      'Tag data is provided to the community free of charge by '
                      'barbershoptags.com.',
                    ),
                    isThreeLine: true,
                    onTap: () async {
                      await launchUrlString(
                        'https://www.barbershoptags.com',
                        mode: .externalApplication,
                      );
                    },
                  ),
                  AboutListTile(
                    applicationName: info.appName,
                    applicationVersion: info.version,
                    applicationIcon: const TaglyIcon(),
                    applicationLegalese:
                        'Copyright © ${DateTime.now().year} Peter Bryant',
                    child: const Text('Licences'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
          'Any sheet music and learning tracks stored offline will '
          'not be available until you view them again.',
    );

    if (!context.mounted) return;
    if (confirmResult != OkCancelResult.ok) return;

    await repository.clearCache();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared')),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader({required this.name, required this.version});

  final String name;
  final String version;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const TaglyIcon(size: 64),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: tt.headlineSmall),
              const SizedBox(height: 2),
              Text(
                'Version $version',
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: tt.labelSmall?.copyWith(
          color: cs.primary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                const Divider(height: 1, indent: 56, endIndent: 0),
            ],
          ],
        ),
      ),
    );
  }
}
