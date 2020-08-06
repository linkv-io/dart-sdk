import '../config/config.dart';
import 'config.dart' show imConfig;

abstract class LvIM {
  factory LvIM() => im._();
}

class im implements LvIM {
  im._();

  imConfig getConfig() {
    return config.im;
  }
}
