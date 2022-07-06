import 'package:flutter/material.dart';

class AutoCompleteOptionsView extends StatelessWidget {
  final Iterable<String> entries;
  final double maxWidth;
  final AutocompleteOnSelected<String> onSelected;

  const AutoCompleteOptionsView(
      {Key? key,
      required this.entries,
      required this.maxWidth,
      required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4.0,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    // color: theme.scaffoldBackgroundColor,
                    child: Text(
                      option,
                      // style: theme.textTheme.textStyle,
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
        ));
  }
}
