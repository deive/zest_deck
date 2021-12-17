import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DeckFileDownloadingWidget extends StatefulWidget {
  const DeckFileDownloadingWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckFileDownloadingWidgetState();
}

class DeckFileDownloadingWidgetState extends State<DeckFileDownloadingWidget> {
  @override
  Widget build(BuildContext context) =>
      Center(child: PlatformCircularProgressIndicator());
}
