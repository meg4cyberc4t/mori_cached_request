import 'package:flutter/material.dart';
import 'package:mori_cached_request/mori_cached_builder.dart';
import 'package:mori_cached_request/mori_cached_request.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  void initState() {
    request.initAsync();
    super.initState();
  }

  @override
  void dispose() {
    request.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => request.update(),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: MoriCachedBuilder<String>(
                  request: request,
                  onData: (context, data, isCache) =>
                      Text("data: ${DateTime.now()}"),
                  onError: (context, error, stackTrace) =>
                      Text('Error: $error'),
                  onLoading: (context) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: MoriCachedBuilder<String>(
                  request: request,
                  onData: (context, data, isCache) =>
                      Text("data: ${DateTime.now()}"),
                  onError: (context, error, stackTrace) =>
                      Text('Error: $error'),
                  onLoading: (context) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
