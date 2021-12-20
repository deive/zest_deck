import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_file_error_widget.dart';
import 'package:zest_deck/app/downloads/deck_file_or_web_widget.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/theme_provider.dart';

class ResourceViewPage extends StatefulWidget {
  const ResourceViewPage(
      {Key? key,
      @pathParam required this.deckId,
      @pathParam required this.resourceId})
      : super(key: key);

  final String deckId;
  final String resourceId;

  @override
  State<StatefulWidget> createState() => ResourceViewPageState();
}

class ResourceViewPageState extends State<ResourceViewPage> {
  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    final deckId = UuidValue(widget.deckId);
    final resourceId = UuidValue(widget.resourceId);
    Deck? deck;
    Resource? resource;
    try {
      deck = decks.decks?.singleWhere((element) => element.id == deckId);
      resource =
          deck?.resources.firstWhere((element) => element.id == resourceId);
    } finally {}

    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(resource?.name ?? ""),
          trailingActions: _buildActions(context),
        ),
        body: resource == null
            // TODO: Better error UI
            ? const DeckFileErrorWidget()
            : ResourceViewWidget(deck: deck!, resource: resource));
  }

  List<Widget> _buildActions(BuildContext context) => platformThemeData(context,
      material: (theme) => _buildActionsMaterial(context),
      cupertino: (theme) => _buildActionsCupertino(context, theme));

  List<Widget> _buildActionsCupertino(
          BuildContext context, CupertinoThemeData theme) =>
      [
        // PlatformIconButton(
        //     onPressed: () => showCupertinoModalPopup(
        //           context: context,
        //           builder: (context) => CupertinoActionSheet(actions: [
        //             CupertinoActionSheetAction(
        //                 onPressed: () => _actionLogout(context),
        //                 child: Text(
        //                   AppLocalizations.of(context)!.zestLogoutAction,
        //                   style:
        //                       TextStyle(color: theme.textTheme.textStyle.color),
        //                 )),
        //             CupertinoActionSheetAction(
        //                 isDefaultAction: true,
        //                 onPressed: () {
        //                   _actionRefresh(context);
        //                   AutoRouter.of(context).pop();
        //                 },
        //                 child: Text(
        //                   AppLocalizations.of(context)!.zestRefreshAction,
        //                   style:
        //                       TextStyle(color: theme.textTheme.textStyle.color),
        //                 ))
        //           ]),
        //         ),
        //     icon: Icon(
        //       CupertinoIcons.ellipsis,
        //       color: theme.textTheme.textStyle.color,
        //     ))
      ];

  List<Widget> _buildActionsMaterial(BuildContext context) => [
        // PopupMenuButton<Actions>(
        //   onSelected: (value) {
        //     switch (value) {
        //       case Actions.logout:
        //         _actionLogout(context);
        //         break;
        //       case Actions.refresh:
        //         _actionRefresh(context);
        //         break;
        //     }
        //   },
        //   itemBuilder: (context) => <PopupMenuEntry<Actions>>[
        //     PopupMenuItem<Actions>(
        //       value: Actions.logout,
        //       child: Text(AppLocalizations.of(context)!.zestLogoutAction),
        //     ),
        //     PopupMenuItem<Actions>(
        //       value: Actions.refresh,
        //       child: Text(AppLocalizations.of(context)!.zestRefreshAction),
        //     ),
        //   ],
        // ),
      ];
}

// enum Actions { logout, refresh }

class ResourceViewWidget extends StatefulWidget {
  const ResourceViewWidget(
      {Key? key, required this.deck, required this.resource})
      : super(key: key);

  final Deck deck;
  final Resource resource;

  @override
  State<StatefulWidget> createState() => ResourceViewWidgetState();
}

class ResourceViewWidgetState extends State<ResourceViewWidget> {
  final _controller = ResourceViewController();
  bool _pagingEnabled = true;

  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    final pages = widget.resource.type == ResourceType.image
        ? widget.resource.files[ResourceFileType.content]
        : widget.resource.files[ResourceFileType.imageContent];
    if (pages == null) return const DeckFileErrorWidget();
    return Stack(children: [
      Scrollbar(
        controller: _controller,
        thickness: ThemeProvider.scrollbarSize,
        child: PageView(
          children: pages.map((e) {
            var transformationController = TransformationController();
            return InteractiveViewer(
              child: LayoutBuilder(
                  builder: (context, constraints) => DeckFileOrWebWidget(
                        downloadBuilder: () {
                          final dl =
                              Provider.of<DecksDownloadProvider>(context);
                          return dl.getFileDownload(widget.deck, e);
                        },
                        urlBuilder: () => decks.fileStorePath(
                            widget.deck.companyId!,
                            widget.resource.thumbnailFile!),
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        fit: BoxFit.contain,
                      )),
              transformationController: transformationController,
              onInteractionUpdate: (details) =>
                  _checkForPagingEnabled(transformationController),
              onInteractionEnd: (details) =>
                  _checkForPagingEnabled(transformationController),
            );
          }).toList(),
          scrollDirection: Axis.horizontal,
          controller: _controller, // widget.controller,
          physics: _pagingEnabled
              ? const PageScrollPhysics()
              : const NeverScrollableScrollPhysics(),
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        PlatformIconButton(
          onPressed: () => _controller.previous(),
          icon: Icon(PlatformIcons(context).leftChevron),
        )
      ]),
      Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlatformIconButton(
              onPressed: () => _controller.next(),
              icon: Icon(PlatformIcons(context).rightChevron),
            ),
          ],
        ),
      ),
    ]);
  }

  void _checkForPagingEnabled(
      TransformationController transformationController) {
    final scale = transformationController.value.getMaxScaleOnAxis();
    final newPagingEnabled = scale <= 1.0;
    if (_pagingEnabled != newPagingEnabled) {
      setState(() {
        _pagingEnabled = newPagingEnabled;
      });
    }
  }
}

class ResourceViewController extends PageController {
  Future<void> next() => nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuart);
  Future<void> previous() => previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuart);
}
