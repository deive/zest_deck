import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/app/file/file_widget.dart';
import 'package:zest/app/main/theme_provider.dart';

/// Shows a given file as an icon at a given size.
class ResourceIconWidget extends StatefulWidget {
  const ResourceIconWidget({
    Key? key,
    required this.borderRadius,
    required this.companyId,
    required this.fileId,
    required this.dimension,
    this.containerColor,
    required this.progress,
    required this.error,
  }) : super(key: key);

  final BorderRadius borderRadius;
  final UuidValue companyId;
  final UuidValue fileId;

  final double dimension;

  final Color? containerColor;
  final Widget Function(BuildContext context) progress;
  final Widget Function(BuildContext context) error;

  @override
  State<StatefulWidget> createState() => ResourceIconWidgetState();
}

class ResourceIconWidgetState extends State<ResourceIconWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return SizedBox.square(
      dimension: widget.dimension,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Container(
          color:
              widget.containerColor ?? themeProvider.deckIconBackgroundColour,
          child: FileWidget(
            companyId: widget.companyId,
            fileId: widget.fileId,
            fit: BoxFit.cover,
            progress: widget.progress,
            error: widget.error,
          ),
        ),
      ),
    );
  }
}
