import 'package:flutter/foundation.dart';

mixin Disposable on ChangeNotifier {
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  void notifyListenersIfNotDisposed() {
    if (!disposed) notifyListeners();
  }
}
