import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/setting_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Dark mode'),
            Switch(value: theme.isDark, onChanged: (_) => theme.toggle()),
          ],
        ),
      ),
    );
  }
}
