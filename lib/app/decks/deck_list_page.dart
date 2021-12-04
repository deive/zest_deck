import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/router.gr.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(AppLocalizations.of(context)!.appName),
          trailingActions: _buildActions(context),
        ),
        body: const DeckListWidget(),
      );

  _actionLogout(BuildContext context) {
    final users = Provider.of<UsersProvider>(context, listen: false);
    users.logout();
  }

  _actionRefresh(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context, listen: false);
    decks.update();
  }

  List<Widget> _buildActions(BuildContext context) => ThemeProvider.isCupertino
      ? _buildActionsCupertino(context)
      : _buildActionsMaterial(context);

  List<Widget> _buildActionsCupertino(BuildContext context) => [
        PlatformIconButton(
          onPressed: () => showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(actions: [
              CupertinoActionSheetAction(
                  onPressed: () => _actionLogout(context),
                  child: Text(AppLocalizations.of(context)!.zestLogoutAction)),
              CupertinoActionSheetAction(
                  onPressed: () => _actionRefresh(context),
                  child: Text(AppLocalizations.of(context)!.zestRefreshAction))
            ]),
          ),
          icon: const Icon(CupertinoIcons.ellipsis),
        )
      ];

  List<Widget> _buildActionsMaterial(BuildContext context) => [
        PopupMenuButton<Actions>(
          onSelected: (value) {
            switch (value) {
              case Actions.logout:
                _actionLogout(context);
                break;
              case Actions.refresh:
                _actionRefresh(context);
                break;
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<Actions>>[
            PopupMenuItem<Actions>(
              value: Actions.logout,
              child: Text(AppLocalizations.of(context)!.zestLogoutAction),
            ),
            PopupMenuItem<Actions>(
              value: Actions.refresh,
              child: Text(AppLocalizations.of(context)!.zestRefreshAction),
            ),
          ],
        ),
      ];
}

enum Actions { logout, refresh }

class DeckListWidget extends StatefulWidget {
  const DeckListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckListWidgetState();
}

class DeckListWidgetState extends State<DeckListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    if (decks.isUpdatingWhileEmpty()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ],
      );
    } else if (decks.decks == null || decks.decks!.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Text(l10n.noDecksMessage);
    } else {
      final orientation = MediaQuery.of(context).orientation;
      return FractionallySizedBox(
        widthFactor: orientation == Orientation.portrait ? 1 : null,
        heightFactor: orientation == Orientation.landscape ? 1 : null,
        child: Scrollbar(
          isAlwaysShown: kIsWeb ||
              Platform.isLinux ||
              Platform.isMacOS ||
              Platform.isWindows,
          interactive: true,
          controller: _scrollController,
          thickness: 15,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            itemCount: decks.decks!.length * 4,
            // TODO: Change to index (and remove * 4 above)
            itemBuilder: (context, index) => DeckWidget(
              deck: decks.decks![0],
              onPressed: () {
                AutoRouter.of(context)
                    .push(DeckDetailRoute(deck: decks.decks![0]));
              },
            ),
          ),
        ),
      );
    }
  }
}

class DeckWidget extends StatefulWidget {
  DeckWidget({Key? key, required this.deck, this.onPressed}) : super(key: key);

// TODO: Date formmating!
  final DateFormat dateFormat = DateFormat.yMMMMEEEEd();
  final Deck deck;
  final void Function()? onPressed;

  @override
  State<StatefulWidget> createState() => DeckWidgetState();
}

class DeckWidgetState extends State<DeckWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deck = widget.deck;
    final orientation = MediaQuery.of(context).orientation;
    return FractionallySizedBox(
      widthFactor: orientation == Orientation.portrait ? 0.75 : null,
      heightFactor: orientation == Orientation.landscape ? 0.75 : null,
      child: AspectRatio(
          aspectRatio: 1,
          child: PlatformIconButton(
            onPressed: widget.onPressed,
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Stack(
                children: [
                  DeckIconWidget(deck: deck),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(100, 100, 100, 100)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(deck.title,
                                    style: platformThemeData(
                                      context,
                                      material: (data) =>
                                          data.textTheme.headline5,
                                      cupertino: (data) =>
                                          data.textTheme.navTitleTextStyle,
                                    )),
                              ),
                              const SizedBox(height: 5),
                              FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(l10n.deckModifiedLabel)),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                    deck.modified?.toIso8601String() ?? ""),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )),
    );
  }
}

class DeckIconWidget extends StatefulWidget {
  const DeckIconWidget({Key? key, required this.deck}) : super(key: key);
  final Deck deck;
  @override
  State<StatefulWidget> createState() => DeckIconWidgetState();
}

class DeckIconWidgetState extends State<DeckIconWidget> {
  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    return CachedNetworkImage(
      imageUrl: decks.fileStorePath(
          widget.deck.companyId!, widget.deck.thumbnailFile!),
      httpHeaders: decks.fileStoreHeaders(),
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          Image.asset("assets/logos/zest_icon.png"),
    );
  }
}
