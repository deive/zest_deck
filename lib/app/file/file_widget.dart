import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/app/file/downloadable_file_widget.dart';
import 'package:zest/app/file/online_file_widget.dart';

/// Displays a file.
/// Uses OnlineFileWidget for the web otherwise DownloadableFileWidget.
class FileWidget extends StatefulWidget {
  const FileWidget({
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
  State<StatefulWidget> createState() => FileWidgetState();
}

class FileWidgetState extends State<FileWidget> {
  @override
  Widget build(BuildContext context) => kIsWeb
      ? OnlineFileWidget(
          companyId: widget.companyId,
          fileId: widget.fileId,
          fit: widget.fit,
          progress: widget.progress,
          error: widget.error,
        )
      : DownloadableFileWidget(
          companyId: widget.companyId,
          fileId: widget.fileId,
          fit: widget.fit,
          progress: widget.progress,
          error: widget.error,
        );
}
