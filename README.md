# mori_cached_request
 The logic of implementing gradual data loading and caching

Creates an abstraction "MoriCachedRequest" for work
```dart
final MoriCachedRequest<String> request = MoriCachedRequest(
    loadingFromCache: () => Future.delayed(
      const Duration(seconds: 3),
      () => "Loading from cache",
    ),
    loadingFromNetwork: () => Future.delayed(
      const Duration(seconds: 3),
      () => "Loading from network",
    ),
    savingToCache: (data) async {
      debugPrint('Saving "$data" to cache');
    },
  );
```
To start, use the init method in initState
```dart
 @override
  void initState() {
    request.initAsync();
    super.initState();
  }
```
So don't forget to free up memory at the end
```dart
 @override
  void dispose() {
    request.dispose();
    super.dispose();
  }
```
To interact with data, you can use request.stream or MoriCachedBuilder like this:
```dart
 MoriCachedBuilder<String>(
  request: request,
  onData: (context, data, isCache) =>
      Text("data: ${DateTime.now()}"),
  onError: (context, error, stackTrace) =>
      Text('Error: $error'),
  onLoading: (context) => const Center(
    child: CircularProgressIndicator.adaptive(),
  ),
),
```