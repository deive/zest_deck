import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/nav_bar.dart';
import 'package:zest/app/title_bar.dart';

class AppPage extends StatelessWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => AppProvider(),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/banner-bg.png"),
                      fit: BoxFit.cover)),
            ),
            // TODO: Add content
            const TitleBar(),
            const NavBar(),
          ],
        ),
      );
}
