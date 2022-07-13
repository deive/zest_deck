import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/title_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleBar(title: AppLocalizations.of(context)!.appNavDecks),
        Padding(
          padding: EdgeInsets.only(left: themeProvider.contentLeftPadding),
          child: const Text("DeckListPage"),
        ),
      ],
    );
  }
}
