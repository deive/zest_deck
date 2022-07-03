import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/zest_icon.dart';
import 'package:zest/generated/l10n.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final app = Provider.of<AppProvider>(context);
    final selectedDeck = app.currentlySelectedDeck;
    final lastSelectedDeck = app.lastSelectedDeck;
    final appBarColour = selectedDeck?.headerColour ?? const Color(0x00000000);
    final width = app.showNavigation ? 76.0 : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      color: appBarColour,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            if (Platform.isAndroid) const SafeArea(child: SizedBox.shrink()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ZestIcon(size: 60.0),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  GestureDetector(
                    onTap: () => {},
                    //AutoRouter.of(context).replace(const DeckListRoute()),
                    child: NavIcon(
                      title: l10n.appNavDecks,
                      child: SvgPicture.asset("assets/home.svg"),
                    ),
                  ),
                  // TODO: Re-add favorites nav when implemented.
                  // NavIcon(
                  //   iconData: PlatformIcons(context).favoriteOutline,
                  //   title: l10n.navFavorites,
                  //   onTap: () =>
                  //       AutoRouter.of(context).replace(const FavoritesRoute()),
                  //   barWidth: width,
                  // ),
                  if (lastSelectedDeck != null)
                    const SizedBox(
                      height: 25,
                    ),
                  if (lastSelectedDeck != null)
                    GestureDetector(
                      onTap: () => {},
                      // AutoRouter.of(context).replace(
                      //     DeckDetailRoute(deckId: lastSelectedDeck.id.uuid)),
                      child: NavIcon(
                        title: lastSelectedDeck.title,
                        child: const Placeholder(),
                        // deck: lastSelectedDeck,
                        // barWidth: width,
                      ),
                    ),
                ],
              ),
            ),
            // TODO: Re-add settings nav when implemented
            // NavIcon(
            //   iconData: PlatformIcons(context).settings,
            //   title: l10n.navSettings,
            //   onTap: () =>
            //       AutoRouter.of(context).replace(const SettingsRoute()),
            //   barWidth: width,
            // ),
          ],
        ),
      ),
    );
  }
}

class NavIcon extends StatelessWidget {
  const NavIcon({Key? key, required this.title, required this.child})
      : super(key: key);
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final selectedDeck = app.currentlySelectedDeck;
    final brightness = MediaQuery.of(context).platformBrightness;
    final defaultColour = brightness == Brightness.dark
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 0, 0, 0);
    final textColour = selectedDeck?.headerTextColour ?? defaultColour;
    return Column(
      children: [
        child,
        Text(title, style: TextStyle(color: textColour)),
      ],
    );
  }
}

// class NavIcon extends StatefulWidget {
//   const NavIcon({
//     Key? key,
//     this.iconData,
//     this.deck,
//     required this.title,
//     required this.barWidth,
//   }) : super(key: key);

//   final IconData? iconData;
//   final Deck? deck;
//   final String title;
//   final double barWidth;

//   @override
//   State<StatefulWidget> createState() => NavIconState();
// }

// class NavIconState extends State<NavIcon> {
//   @override
//   Widget build(BuildContext context) {
//     final width = widget.barWidth - 10;
//     if (width <= 0) return const SizedBox.shrink();
//     final app = Provider.of<AppProvider>(context);
//     final selectedDeck = app.currentlySelectedDeck;
//     final brightness = MediaQuery.of(context).platformBrightness;
//     final defaultColour = brightness == Brightness.dark
//         ? const Color.fromARGB(255, 255, 255, 255)
//         : const Color.fromARGB(255, 0, 0, 0);
//     final textColour = selectedDeck?.headerTextColour ?? defaultColour;
//     return Column(children: [
//       if (widget.iconData != null)
//         Icon(
//           widget.iconData,
//           semanticLabel: widget.title,
//           size: width,
//           color: textColour,
//         ),
//       if (widget.deck != null)
//         SizedBox.square(dimension: width, child: const Placeholder()
//             // DeckIconWidget(
//             //   deck: widget.deck!,
//             //   borderRadius: BorderRadius.circular(5),
//             // ),
//             ),
//       if (widget.deck != null)
//         const SizedBox(
//           height: 5,
//         ),
//       Text(widget.title, style: TextStyle(color: textColour)),
//       const SizedBox(height: 5),
//     ]);
//   }
// }
