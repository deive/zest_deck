import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/title_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.watch();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleBar(title: AppLocalizations.of(context)!.appNavSettings),
        Padding(
          padding: EdgeInsets.only(left: themeProvider.contentLeftPadding),
          child: const Text("SettingsPage"),
        ),
        Padding(
          padding: EdgeInsets.only(left: themeProvider.contentLeftPadding),
          child: ElevatedButton(
            onPressed: () => {context.read<AuthProvider>().logout()},
            child: const Text("Logout"),
          ),
        )
      ],
    );
  }
}
