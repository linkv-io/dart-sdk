import 'dart:async';
import 'package:pool/pool.dart';
import 'package:dio/dio.dart';

class _Http {
  final Pool pool;
  final String version;

  _Http(this.version, int poolSize) : pool = Pool(poolSize);

  Dio _open() {
    return Dio();
  }

  void _close(Dio dio) {
    return dio.close(force: true);
  }

  Future<T> invoke<T>(
    FutureOr<T> Function(Dio dio) callback,
  ) async {
    return pool.withResource(() async {
      var conn = _open();
      try {
        return await callback(conn);
      } finally {
        _close(conn);
      }
    });
  }

  Future<Response> PostDataWithHeader(String url, Map<String, String> params,
      {Map<String, String> headers}) {
    return invoke((dio) {
      if (headers == null) {
        headers = {
          Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
          'User-Agent': 'Dart SDK v${version}',
        };
        return dio.post(
          url,
          queryParameters: params,
          options: Options(headers: headers),
        );
      }
      headers[Headers.contentTypeHeader] = Headers.formUrlEncodedContentType;
      headers['User-Agent'] = 'Dart SDK v${version}';
      return dio.post(
        url,
        queryParameters: params,
        options: Options(headers: headers),
      );
    });
  }

  Future<Response> GetDataWithHeader(String url, Map<String, String> params,
      {Map<String, String> headers}) {
    return invoke((dio) {
      if (headers == null) {
        headers = {
          'User-Agent': 'Dart SDK v${version}',
        };
        return dio.get(
          url,
          queryParameters: params,
          options: Options(headers: headers),
        );
      }
      headers['User-Agent'] = 'Dart SDK v${version}';
      return dio.get(
        url,
        queryParameters: params,
        options: Options(headers: headers),
      );
    });
  }
}

_Http _cachedConfig;

_Http http({String version, int poolSize = 10}) {
  return _cachedConfig ??= _Http(version, poolSize);
}
