import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/main/auth_and_sync_action.dart';
import 'package:zest_deck/app/main/overflow_actions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(AppLocalizations.of(context)!.appName),
          trailingActions: const [
            AuthAndSyncAction(),
            OverflowActions(),
          ],
        ),
        body: const Text("SETTINGS WILL BE HERE!"));
  }
}
