import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/gesture_detector_region.dart';

class RefreshAction extends StatelessWidget {
  const RefreshAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();

    final authProvider = context.watch<AuthProvider>();
    final deckListProvider = context.watch<DeckListProvider>();

    if (!authProvider.initComplete || !deckListProvider.initComplete) {
      return const SizedBox.shrink();
    } else if (!authProvider.isCurrentUserAPISessionValid) {
      return _icon(
        context,
        "assets/account-login.svg",
        () => context.read<AuthProvider>().requestRelogin(),
      );
    } else if (deckListProvider.isUpdating) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: AspectRatio(
          aspectRatio: 1,
          child: PlatformCircularProgressIndicator(
            material: (context, platform) => MaterialProgressIndicatorData(
              color: context.watch<ThemeProvider>().foregroundColour,
            ),
            cupertino: (context, platform) => CupertinoProgressIndicatorData(
              color: context.watch<ThemeProvider>().foregroundColour,
            ),
          ),
        ),
      );
    } else {
      return _icon(
        context,
        "assets/reload.svg",
        () => context.read<DeckListProvider>().updateDecksFromAPI(),
      );
    }
  }

  Widget _icon(
          BuildContext context, String assetName, GestureTapCallback onTap) =>
      GestureDetectorRegion(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: AspectRatio(
            aspectRatio: 1,
            child: SvgPicture.asset(
              assetName,
              color: context.watch<ThemeProvider>().headerTextColour,
            ),
          ),
        ),
      );
}
