import 'package:flutter/material.dart';
import 'package:mori_cached_request/mori_cached_request.dart';
import 'package:mori_cached_request/mori_cached_state.dart';

typedef OnDataCallback<T> = Widget Function(
    BuildContext context, T data, bool isCache);
typedef OnLoadingCallback = Widget Function(BuildContext context);
typedef OnErrorCallback = Widget Function(
  BuildContext context,
  Object? error,
  StackTrace? stackTrace,
);

class MoriCachedBuilder<T> extends StatelessWidget {
  const MoriCachedBuilder({
    required this.request,
    required this.onData,
    this.onError,
    this.onLoading,
    Key? key,
  }) : super(key: key);
  final MoriCachedRequest<T> request;
  final OnDataCallback<T> onData;
  final OnLoadingCallback? onLoading;
  final OnErrorCallback? onError;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MoriCachedState<T>>(
      stream: request.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return onData(
            context,
            snapshot.data!.value,
            snapshot.data!.isCache,
          );
        }
        if (snapshot.hasError && onError != null) {
          return onError!.call(
            context,
            snapshot.error,
            snapshot.stackTrace,
          );
        }
        return onLoading?.call(context) ?? const SizedBox.shrink();
      },
    );
  }
}
