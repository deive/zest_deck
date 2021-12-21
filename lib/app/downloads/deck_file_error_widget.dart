import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';

class DeckFileErrorWidget extends StatefulWidget {
  final DeckFileDownloader? downloader;
  final double? width;
  final double? height;

  const DeckFileErrorWidget(
      {Key? key, this.downloader, this.width, this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckFileErrorWidgetState();
}

class DeckFileErrorWidgetState extends State<DeckFileErrorWidget> {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.9,
                child: Image.asset(
                  "assets/logos/zest_icon.png",
                  fit: BoxFit.contain,
                  color: Colors.grey,
                  colorBlendMode: BlendMode.srcATop,
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 100 &&
                    widget.downloader?.hasAuthFail == true) {
                  final l10n = AppLocalizations.of(context)!;
                  return Center(
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.deckIconAuthErrorMessage,
                            style: platformThemeData(
                              context,
                              material: (theme) => theme.textTheme.bodyText1,
                              cupertino: (theme) => theme.textTheme.textStyle,
                            ),
                          )));
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      );
}
