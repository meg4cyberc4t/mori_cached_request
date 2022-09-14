library mori_cached_request;

import 'dart:async';

import 'package:mori_cached_request/mori_cached_state.dart';

/// A Calculator.
class MoriCachedRequest<T> {
  MoriCachedRequest({
    required this.loadingFromCache,
    required this.loadingFromNetwork,
    required this.savingToCache,
  });
  final Future<T?> Function() loadingFromCache;
  final Future<void> Function(T data) savingToCache;
  final Future<T> Function() loadingFromNetwork;

  final StreamController<MoriCachedState<T>> _streamController =
      StreamController<MoriCachedState<T>>();

  late final Stream<MoriCachedState<T>> stream =
      _streamController.stream.asBroadcastStream();

  Future<void> initAsync() async {
    if (_streamController.hasListener) return;
    final T? oldData = await loadingFromCache();
    if (oldData != null) {
      _streamController.add(
        MoriCachedState(isCache: true, value: oldData),
      );
    }
    await update();
  }

  Future<void> update() async {
    final T newData = await loadingFromNetwork();
    _streamController.add(
      MoriCachedState(isCache: false, value: newData),
    );
    await savingToCache(newData);
  }

  void dispose() {
    _streamController.close();
  }
}
