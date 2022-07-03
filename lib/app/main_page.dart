import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/main_provider.dart';
import 'package:zest/app/navigation/nav_bar.dart';
import 'package:zest/app/shared/title_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) =>
            MainProvider(Provider.of<AppProvider>(context, listen: false)),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/banner-bg.png"),
                      fit: BoxFit.cover)),
            ),
            const AutoRouter(),
            const TitleBar(),
            const NavBar(),
          ],
        ),
      );
}
