import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

/// Downloads and shows a file.
class DownloadableFileWidget extends StatefulWidget {
  const DownloadableFileWidget({
    Key? key,
    required this.companyId,
    required this.fileId,
    required this.fit,
    required this.progress,
    required this.error,
  }) : super(key: key);

  final UuidValue companyId;
  final UuidValue fileId;

  final BoxFit fit;
  final Widget Function(BuildContext context) progress;
  final Widget Function(BuildContext context) error;

  @override
  State<StatefulWidget> createState() => DownloadableFileWidgetState();
}

class DownloadableFileWidgetState extends State<DownloadableFileWidget> {
  @override
  Widget build(BuildContext context) =>
      widget.error(context); // TODO: Downloadable image
}
