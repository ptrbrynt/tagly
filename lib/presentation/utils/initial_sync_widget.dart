import 'package:flutter/material.dart';
import 'package:tagly/presentation/utils/tagly_icon.dart';

class InitialSyncWidget extends StatelessWidget {
  const InitialSyncWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: TaglyIcon(size: 96)),
            const SizedBox(height: 32),
            Text(
              'Tagly',
              style: theme.textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'The best way to learn barbershop tags',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 20),
            Text(
              "Syncing tags. Don't go away...",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
