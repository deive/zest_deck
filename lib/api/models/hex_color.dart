import 'package:flutter/widgets.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor, String? alphaPercent) {
    var alphaHex = "FF";
    if (alphaPercent != null && alphaPercent.endsWith("%")) {
      final alphaP = int.parse(alphaPercent.replaceAll("%", ""));
      final alpha = ((255 / 100) * alphaP).round();
      alphaHex = alpha.toRadixString(16);
    }
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    hexColor = "$alphaHex$hexColor";
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor, String? alphaPercent)
      : super(_getColorFromHex(hexColor, alphaPercent));
}
