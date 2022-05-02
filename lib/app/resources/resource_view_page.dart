import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_file_error_widget.dart';
import 'package:zest_deck/app/downloads/deck_file_or_web_widget.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';
import 'package:zest_deck/app/main/auth_and_sync_action.dart';
import 'package:zest_deck/app/main/overflow_actions.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/re_login_dialog.dart';

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
          title: Text(
            resource?.name ?? "",
            style: TextStyle(
              color: deck?.headerTextColour,
            ),
          ),
          trailingActions: const [
            AuthAndSyncAction(),
            OverflowActions(),
          ],
          backgroundColor: deck?.headerColour,
        ),
        body: resource == null
            // TODO: Better error UI
            ? const DeckFileErrorWidget()
            : ResourceViewWidget(deck: deck!, resource: resource));
  }
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
    if (pages == null) {
      return const DeckFileErrorWidget();
    } else if (pages.length == 1) {
      return _resourceView(decks, pages.first);
    } else {
      return _pagedView(decks, pages);
    }
  }

  Widget _pagedView(DecksProvider decks, List<UuidValue> pages) {
    return Stack(children: [
      Scrollbar(
        controller: _controller,
        thickness: ThemeProvider.scrollbarSize,
        child: PageView(
          children: pages.map((e) {
            var transformationController = TransformationController();
            return GestureDetector(
              onTap: () async {
                bool showLogin = false;
                if (!kIsWeb) {
                  // Check for failed login on icon download
                  final dl = Provider.of<DecksDownloadProvider>(context,
                      listen: false);
                  final d = await dl.getFileDownload(widget.deck, e);
                  showLogin = d?.hasAuthFail ?? false;
                }
                if (showLogin) {
                  showReLoginDialog(context);
                }
              },
              child: InteractiveViewer(
                child: _resourceView(decks, e),
                transformationController: transformationController,
                onInteractionUpdate: (details) =>
                    _checkForPagingEnabled(transformationController),
                onInteractionEnd: (details) =>
                    _checkForPagingEnabled(transformationController),
              ),
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

  Widget _resourceView(DecksProvider decks, UuidValue resource) =>
      LayoutBuilder(
          builder: (context, constraints) => DeckFileOrWebWidget(
                downloadBuilder: () {
                  final dl = Provider.of<DecksDownloadProvider>(context);
                  return dl.getFileDownload(widget.deck, resource);
                },
                urlBuilder: () => decks.fileStorePath(
                    widget.deck.companyId!, widget.resource.thumbnailFile!),
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                fit: BoxFit.contain,
              ));

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
