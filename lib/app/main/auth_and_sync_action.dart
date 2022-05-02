import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/users/re_login_dialog.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class AuthAndSyncAction extends StatefulWidget {
  const AuthAndSyncAction({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AuthAndSyncActionState();
}

class AuthAndSyncActionState extends State<AuthAndSyncAction> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();
    final users = Provider.of<UsersProvider>(context);
    final decks = Provider.of<DecksProvider>(context);
    final hasAuth = users.currentData?.authToken != null;
    final isRefreshing = decks.isUpdatingWhileNotEmpty;
    return SizedBox(
      height: kToolbarHeight,
      child: AspectRatio(
          aspectRatio: 1,
          child: isRefreshing
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PlatformCircularProgressIndicator(
                    material: (context, platform) =>
                        MaterialProgressIndicatorData(
                            strokeWidth: 2,
                            color:
                                Theme.of(context).appBarTheme.foregroundColor),
                  ),
                ))
              : PlatformIconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(hasAuth
                      ? PlatformIcons(context).checkMarkCircledSolid
                      : PlatformIcons(context).error),
                  onPressed: () {
                    if (!hasAuth) {
                      showReLoginDialog(context);
                    } else if (!isRefreshing) {
                      decks.updateDecksFromAPI();
                    }
                  },
                )),
    );
  }
}
