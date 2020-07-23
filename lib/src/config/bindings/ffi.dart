import 'dart:ffi';
import 'dart:io'
    show
        Platform,
        Directory,
        File,
        HttpClient,
        HttpClientRequest,
        HttpClientResponse,
        HttpStatus;

String _platformFile(String name) {
  if (Platform.isLinux) {
    return 'lib${name}.so';
  }
  if (Platform.isMacOS) {
    return 'lib${name}.dylib';
  }
  if (Platform.isWindows) {
    return 'lib${name}.dll';
  }
  throw Exception('Platform not implemented');
}

DynamicLibrary dlopenPlatformSpecific(String name, {String path = ''}) {
  if (path.isEmpty) {
    path = Directory.systemTemp.uri.path;
  }
  return DynamicLibrary.open('${path}${_platformFile(name)}');
}

const DownloadURL = 'http://dl.linkv.fun/static/server';

Future<bool> download(String name, {String path = '', version = ''}) {
  if (path.isEmpty) {
    path = Directory.systemTemp.uri.path;
  }
  final hClient = HttpClient();
  final f = File('${path}${_platformFile(name)}');
  return f.exists().then((value) => value
      ? Future.value(true)
      : hClient
          .getUrl(Uri.parse('${DownloadURL}/${version}/${_platformFile(name)}'))
          .then((HttpClientRequest req) => req.close())
          .then((HttpClientResponse resp) => HttpStatus.ok != resp.statusCode
              ? Future(() => hClient.close(force: true))
                  .then((_) => Future.value(false))
              : resp.pipe(f.openWrite()).then((_) =>
                  Future(() => hClient.close(force: true))
                      .then((_) => Future.value(true)))));
}
