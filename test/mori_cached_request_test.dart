import 'package:flutter_test/flutter_test.dart';
import 'package:mori_cached_request/mori_cached_request.dart';

void main() {
  test('testing the basic logic', () async {
    final req = MoriCachedRequest<String>(
      loadingFromCache: () async => "cache",
      loadingFromNetwork: () async => "network",
      savingToCache: (data) async {},
    );
    await req.initAsync();
    expect((await req.stream.first).value, "cache");
    expect((await req.stream.first).value, "network");
    req.dispose();
  });
}
