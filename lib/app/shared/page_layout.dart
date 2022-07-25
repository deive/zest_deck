import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:zest/app/shared/title_bar.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({Key? key, required this.title, required this.child})
      : super(key: key);
  final TitleBar title;
  final Widget child;

  @override
  Widget build(BuildContext context) => (Platform.isAndroid || Platform.isIOS)
      ? SafeArea(
          child: Stack(
            children: [child, title],
          ),
        )
      : Stack(
          children: [child, title],
        );
}
