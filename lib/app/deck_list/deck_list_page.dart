import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/page_layout.dart';
import 'package:zest/app/shared/title_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) =>
            DeckListProvider(context.read(), context.read(), context.read()),
        child: Builder(builder: (context) {
          return PageLayout(
              title: TitleBar(title: AppLocalizations.of(context)!.appNavDecks),
              child: _deckLayout(context));
        }),
      );

  Widget _deckLayout(BuildContext context) {
    final deckListProvider = Provider.of<DeckListProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    if (deckListProvider.isFirstFetch) {
      // TODO: Error on first load UI.
      return Center(child: PlatformCircularProgressIndicator());
    } else if (deckListProvider.decks == null ||
        deckListProvider.decks!.isEmpty) {
      return _simpleError(context, l10n.deckListNoDecksMessage);
    } else {
      return _deckList(context);
    }
  }

  Widget _simpleError(BuildContext context, String text) => Center(
      child: Text(text,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.headline1,
            cupertino: (data) => data.textTheme.navLargeTitleTextStyle,
          )));

  Widget _deckList(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: EdgeInsets.only(
          left: themeProvider.contentLeftPadding,
          top: themeProvider.titleHeight),
      child: FractionallySizedBox(
        widthFactor: orientation == Orientation.portrait ? 1 : null,
        heightFactor: orientation == Orientation.landscape ? 1 : null,
        child: Stack(
          children: const [Placeholder(), Text("DeckListPage")],
        ),
      ),
    );
  }
}
