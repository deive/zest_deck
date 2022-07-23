import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/deck_list/deck_list.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/page_layout.dart';
import 'package:zest/app/shared/title_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProxyProvider<AuthProvider, DeckListProvider>(
        create: (context) =>
            DeckListProvider(context.read(), context.read(), null),
        update: (BuildContext context, value, DeckListProvider? previous) =>
            DeckListProvider(context.read(), context.read(), value),
        child: Builder(builder: (context) {
          return PageLayout(
              title: TitleBar(title: AppLocalizations.of(context)!.appNavDecks),
              child: AnimatedSwitcher(
                  duration:
                      context.watch<ThemeProvider>().fastTransitionDuration,
                  child: _deckLayout(context)));
        }),
      );

  Widget _deckLayout(BuildContext context) {
    final deckListProvider = context.watch<DeckListProvider>();
    final l10n = AppLocalizations.of(context)!;
    if (!deckListProvider.initComplete) {
      return _fullLoading();
    } else if (deckListProvider.isFirstFetch) {
      if (deckListProvider.updateCall?.error != null) {
        return _simpleError(context, l10n.deckListNoDecksErrorMessage);
      } else {
        return _fullLoading();
      }
    } else if (deckListProvider.decks == null ||
        deckListProvider.decks!.isEmpty) {
      return _simpleError(context, l10n.deckListNoDecksMessage);
    } else {
      return DeckList(
        decks: deckListProvider.decks!,
        onPressed: (deck) {
          context.read<MainProvider>().navigateToDeck(deck);
        },
      );
    }
  }

  Widget _fullLoading() => Center(child: PlatformCircularProgressIndicator());

  Widget _simpleError(BuildContext context, String text) => Center(
      child: Text(text,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.headline1,
            cupertino: (data) => data.textTheme.navLargeTitleTextStyle,
          )));
}
