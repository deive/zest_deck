import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/main/auth_and_sync_action.dart';
import 'package:zest_deck/app/main/overflow_actions.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
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
        body: const Text("Favorites WILL BE HERE!"));
  }
}
