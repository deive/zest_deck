import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/theme_provider.dart';

class AutoCompleteOptionsView extends PlatformWidget {
  final Iterable<String> entries;
  final double maxWidth;
  final AutocompleteOnSelected<String> onSelected;

  AutoCompleteOptionsView(
      {Key? key,
      required this.entries,
      required this.maxWidth,
      required this.onSelected})
      : super(key: key);

  @override
  Widget createMaterialWidget(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              final String option = entries.elementAt(index);
              return GestureDetector(
                onTap: () {
                  onSelected(option);
                },
                child: ListTile(
                  title: Text(option),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              height: 2,
              indent: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget createCupertinoWidget(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final String option = entries.elementAt(index);
              return GestureDetector(
                onTap: () {
                  onSelected(option);
                },
                child: Container(
                  padding: ThemeProvider.listItemInsets,
                  color: theme.scaffoldBackgroundColor,
                  child: Text(
                    option,
                    style: theme.textTheme.textStyle,
                    maxLines: 1,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              height: 2,
              indent: 2,
            ),
          ),
        ),
      ),
    );
  }
}
