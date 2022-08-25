import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/gesture_detector_region.dart';

class RefreshAction extends StatelessWidget {
  const RefreshAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        child: _build(context),
      );

  Widget _build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final deckListProvider = context.watch<DeckListProvider>();

    if (!authProvider.initComplete || !deckListProvider.initComplete) {
      return const SizedBox.shrink();
    } else if (!authProvider.isCurrentUserAPISessionValid) {
      return _icon(
        context,
        CupertinoIcons.person_crop_circle_badge_exclam,
        () => context.read<AuthProvider>().requestRelogin(),
      );
    } else if (deckListProvider.isUpdating) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: PlatformCircularProgressIndicator(
          material: (context, platform) => MaterialProgressIndicatorData(
            strokeWidth: 2,
            color: context.watch<ThemeProvider>().headerTextColour,
          ),
          cupertino: (context, platform) => CupertinoProgressIndicatorData(
            color: context.watch<ThemeProvider>().headerTextColour,
          ),
        ),
      );
    } else {
      return _icon(
        context,
        CupertinoIcons.arrow_2_circlepath,
        () => context.read<DeckListProvider>().updateDecksFromAPI(),
      );
    }
  }

  Widget _icon(BuildContext context, IconData icon, GestureTapCallback onTap) =>
      GestureDetectorRegion(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Icon(
            icon,
            color: context.watch<ThemeProvider>().headerTextColour,
          ),
        ),
      );
}
