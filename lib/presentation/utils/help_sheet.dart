// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

class HelpStep {
  const HelpStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class HelpSheet extends StatelessWidget {
  const HelpSheet._({
    required this.steps,
    required this.title,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<HelpStep> steps,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return HelpSheet._(
          steps: steps,
          title: title,
        );
      },
    );
  }

  final String title;
  final List<HelpStep> steps;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const .all(24),
      shrinkWrap: true,
      children: [
        Text(title, style: textTheme.titleLarge),
        const SizedBox(height: 24),
        for (final step in steps) ...[
          _HelpStepWidget.fromStep(step),
          if (step != steps.last) const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _HelpStepWidget extends StatelessWidget {
  const _HelpStepWidget({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory _HelpStepWidget.fromStep(HelpStep step) => _HelpStepWidget(
    icon: step.icon,
    title: step.title,
    description: step.description,
  );

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: cs.primaryContainer,
          child: Icon(icon, size: 16, color: cs.onPrimaryContainer),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
