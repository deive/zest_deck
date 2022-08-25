import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main/theme_provider.dart';

/// Shows a general error icon.
class ResourceIconErrorWidget extends StatelessWidget {
  const ResourceIconErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return FractionallySizedBox(
      heightFactor: 0.6,
      widthFactor: 0.6,
      child: FittedBox(
        child: Icon(
          CupertinoIcons.photo,
          color: themeProvider.deckDetailsBackgroundColour,
        ),
      ),
    );
  }
}
