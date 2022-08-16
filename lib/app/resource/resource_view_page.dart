import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource.dart';
import 'package:zest/app/resource/resource_icon.dart';
import 'package:zest/app/shared/page_layout.dart';
import 'package:zest/app/shared/title_bar.dart';

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
    final deckListProvider = context.watch<DeckListProvider>();
    UuidValue? deckId;
    UuidValue? resourceId;
    try {
      deckId = UuidValue(widget.deckId);
      resourceId = UuidValue(widget.resourceId);
    } catch (_) {}
    final deck = deckId == null ? null : deckListProvider.getDeck(deckId);
    final resource = resourceId == null ? null : deck?.getResource(resourceId);

    Widget child;
    if (resource == null) {
      child = _notFound();
    } else {
      child = ResourceViewWidget(deck: deck!, resource: resource);
    }

    return PageLayout(
      title: _deckTitleBar(
        context,
        deck,
        resource,
      ),
      child: child,
    );
  }

  TitleBarWidget? _deckTitleBar(
      BuildContext context, Deck? deck, Resource? resource) {
    if (deck?.windowStyle == DeckWindowStyle.noTitle) {
      return null;
    } else {
      return TitleBarWidget(
        title: resource?.name ??
            AppLocalizations.of(context)!.resourceNotFoundTitle,
      );
    }
  }

  // TODO: Resource not found UI.
  Widget _notFound() =>
      Text(AppLocalizations.of(context)!.resourceNotFoundMessage);
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
    final deckListProvider = context.watch<DeckListProvider>();
    final pages = widget.resource.type == ResourceType.image
        ? widget.resource.files[ResourceFileType.content]
        : widget.resource.files[ResourceFileType.imageContent];
    if (pages == null) {
      return _notFound();
    } else if (pages.length == 1) {
      return _resourceView(deckListProvider, pages.first);
    } else {
      return _pagedView(deckListProvider, pages);
    }
  }

  Widget _pagedView(DeckListProvider decks, List<UuidValue> pages) {
    final themeProvider = context.watch<ThemeProvider>();
    return Stack(children: [
      Scrollbar(
        controller: _controller,
        thickness: themeProvider.scrollbarSize,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            themeProvider.contentLeftPadding,
            themeProvider.contentTopPadding,
            0,
            0,
          ),
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: _controller, // widget.controller,
            physics: _pagingEnabled
                ? const PageScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            children: pages.map((e) {
              var transformationController = TransformationController();
              return GestureDetector(
                onTap: () async {
                  // bool showLogin = false;
                  // if (!kIsWeb) {
                  //   // Check for failed login on icon download
                  //   final dl = Provider.of<DecksDownloadProvider>(context,
                  //       listen: false);
                  //   final d = await dl.getFileDownload(widget.deck, e);
                  //   showLogin = d?.hasAuthFail ?? false;
                  // }
                  // if (showLogin) {
                  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  //     showReLoginDialog(context);
                  //   });
                  // }
                },
                child: InteractiveViewer(
                  transformationController: transformationController,
                  onInteractionUpdate: (details) =>
                      _checkForPagingEnabled(transformationController),
                  onInteractionEnd: (details) =>
                      _checkForPagingEnabled(transformationController),
                  child: _resourceView(decks, e),
                ),
              );
            }).toList(),
          ),
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

  Widget _resourceView(DeckListProvider decks, UuidValue resource) {
    final themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        themeProvider.contentLeftPadding,
        themeProvider.contentTopPadding,
        0,
        0,
      ),
      child: SizedBox.expand(
        child: ResourceWidget(
          deck: widget.deck,
          resourceId: resource,
        ),
      ),
    );
  }
  // LayoutBuilder(
  //   builder: (context, constraints) => ResourceIconWidget(
  //     borderRadius: BorderRadius.zero,
  //     deck: widget.deck,
  //     resourceId: resource,
  //     dimension: constraints.maxHeight,
  //   ),

  // DeckFileOrWebWidget(
  //   downloadBuilder: () {
  //     final dl = Provider.of<DecksDownloadProvider>(context);
  //     return dl.getFileDownload(widget.deck, resource);
  //   },
  //   urlBuilder: () => decks.fileStorePath(
  //       widget.deck.companyId!, widget.resource.thumbnailFile!),
  //   width: constraints.maxWidth,
  //   height: constraints.maxHeight,
  //   fit: BoxFit.contain,
  // ),
  // );

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

  // TODO: Pages not found UI.
  Widget _notFound() =>
      Text(AppLocalizations.of(context)!.resourceNoPagesErrorMessage);
}

class ResourceViewController extends PageController {
  Future<void> next() => nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuart);
  Future<void> previous() => previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuart);
}
