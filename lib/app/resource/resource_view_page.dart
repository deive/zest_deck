import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

class ResourceViewPage extends StatelessWidget {
  const ResourceViewPage(
      {Key? key,
      @pathParam required this.deckId,
      @pathParam required this.resourceId})
      : super(key: key);

  final String deckId;
  final String resourceId;

  @override
  Widget build(BuildContext context) {
    return Text("ResourceViewPage: $deckId, $resourceId");
  }
}
