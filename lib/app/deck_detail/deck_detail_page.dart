import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/deck_detail/deck_section_widget.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource_icon.dart';
import 'package:zest/app/shared/page_layout.dart';
import 'package:zest/app/shared/title_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeckDetailPage extends StatefulWidget {
  const DeckDetailPage({Key? key, @pathParam required this.deckId})
      : super(key: key);

  final String deckId;

  @override
  State<StatefulWidget> createState() => DeckDetailPageState();
}

class DeckDetailPageState extends State<DeckDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final deckListProvider = context.read<DeckListProvider>();
    final deck = _getDeck(deckListProvider);
    if (deck != null) {
      context.read<MainProvider>().onNavigatedToDeck(deck);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deckListProvider = context.watch<DeckListProvider>();
    final deck = _getDeck(deckListProvider);
    Widget child;
    if (deck == null) {
      child = _notFound();
    } else {
      child = Stack(
        children: [
          if (deck.backgroundImageResourceId != null)
            LayoutBuilder(builder: (context, constraints) {
              final resource =
                  deck.getResource(deck.backgroundImageResourceId!);
              final resourceFile = resource?.contentFile;
              if (resourceFile == null) return const SizedBox.shrink();
              double dimension;
              if (constraints.maxHeight > constraints.maxWidth) {
                dimension = constraints.maxHeight;
              } else {
                dimension = constraints.maxWidth;
              }
              return ResourceIconWidget(
                borderRadius: BorderRadius.zero,
                companyId: deck.companyId!,
                fileId: resourceFile,
                dimension: dimension,
                containerColor: const Color(0x00000000),
                progress: (context) => const SizedBox.shrink(),
                error: (context) => const SizedBox.shrink(),
              );
            }),
          _deckPage(context, deck),
        ],
      );
    }

    return PageLayout(
      title: _deckTitleBar(context, deck),
      child: child,
    );
  }

  Deck? _getDeck(DeckListProvider deckListProvider) {
    UuidValue? id;
    try {
      id = UuidValue(widget.deckId);
    } catch (_) {}
    return id == null ? null : deckListProvider.getDeck(id);
  }

  Widget _deckPage(BuildContext context, Deck deck) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scrollbar(
      thumbVisibility:
          kIsWeb || Platform.isLinux || Platform.isMacOS || Platform.isWindows,
      interactive: true,
      controller: _scrollController,
      thickness: themeProvider.scrollbarSize,
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              themeProvider.contentTopPadding,
        ),
        controller: _scrollController,
        scrollDirection:
            deck.flow == DeckFlow.horizontal ? Axis.vertical : Axis.horizontal,
        itemCount: deck.sections.length,
        itemBuilder: (context, index) => DeckSectionWidget(
          deck: deck,
          section: deck.sections[index],
        ),
      ),
    );
  }

  TitleBarWidget? _deckTitleBar(BuildContext context, Deck? deck) {
    if (deck?.windowStyle == DeckWindowStyle.noTitle) {
      return null;
    } else {
      return TitleBarWidget(
        title: deck?.title ??
            AppLocalizations.of(context)!.deckDetailNotFoundTitle,
      );
    }
  }

  // TODO: Deck not found UI.
  Widget _notFound() =>
      Text(AppLocalizations.of(context)!.deckDetailNotFoundMessage);
}
