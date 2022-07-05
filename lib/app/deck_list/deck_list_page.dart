import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main_provider.dart';
import 'package:zest/app/shared/title_bar.dart';
import 'package:zest/generated/l10n.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleBar(title: S.of(context).appNavDecks),
        Padding(
          padding: EdgeInsets.only(left: themeProvider.contentLeftPadding),
          child: const Text("DeckListPage"),
        ),
      ],
    );
  }
}