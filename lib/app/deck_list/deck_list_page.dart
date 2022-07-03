import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main_provider.dart';
import 'package:zest/app/shared/title_bar.dart';
import 'package:zest/generated/l10n.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleBar(title: S.of(context).appNavDecks),
        Padding(
          padding: EdgeInsets.only(left: mainProvider.getContentLeftPadding()),
          child: const Text("DeckListPage"),
        ),
      ],
    );
  }
}
