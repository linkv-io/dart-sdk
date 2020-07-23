import '../config/config.dart';
import 'config.dart' show imConfig;

class _IM {
  _IM();

  imConfig getConfig() {
    return config.im;
  }
}

_IM _cachedIM;

_IM get im => _cachedIM ??= _IM();
