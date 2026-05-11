import 'package:flutter/material.dart';
import 'package:tagly/data/settings_repository.dart';

class AnalyticsToggle extends StatefulWidget {
  const AnalyticsToggle({required this.repository, super.key});

  final SettingsRepository repository;

  @override
  State<AnalyticsToggle> createState() => _AnalyticsToggleState();
}

class _AnalyticsToggleState extends State<AnalyticsToggle> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final result = await widget.repository.isAnalyticsEnabled;
    if (!mounted) return;
    setState(() {
      _isEnabled = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: const Text('Enable anonymous analytics'),
      subtitle: const Text(
        '''Help us improve the app. We never sell your data or identify you personally.''',
      ),
      value: _isEnabled,
      onChanged: (value) async {
        await (value
                ? widget.repository.enableAnalytics()
                : widget.repository.disableAnalytics())
            .whenComplete(_load);
      },
    );
  }
}
