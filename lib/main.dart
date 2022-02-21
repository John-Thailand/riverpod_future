import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_future/provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postalCode = ref.watch(apiProvider);
    final familyPostalCode =
        ref.watch(apiFamilyProvider(ref.watch(postalCodeProvider)));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (text) {
                onPostalCodeChanged(text, ref);
              },
            ),
            Text('without family'),
            Expanded(
              child: postalCode.when(
                data: (data) => ListView.separated(
                  itemCount: data.data.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Column(
                      children: [
                        Text(data.data[index].en.prefecture),
                        Text(data.data[index].en.address1),
                        Text(data.data[index].en.address2),
                        Text(data.data[index].en.address3),
                        Text(data.data[index].en.address4),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.black),
                ),
                error: (error, stack) => Text(error.toString()),
                loading: () => AspectRatio(
                  aspectRatio: 1,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
            Text('with family'),
            Expanded(
              child: familyPostalCode.when(
                data: (data) => ListView.separated(
                  itemCount: data.data.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Column(
                      children: [
                        Text(data.data[index].en.prefecture),
                        Text(data.data[index].en.address1),
                        Text(data.data[index].en.address2),
                        Text(data.data[index].en.address3),
                        Text(data.data[index].en.address4),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.black),
                ),
                error: (error, stack) => Text(error.toString()),
                loading: () => AspectRatio(
                  aspectRatio: 1,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onPostalCodeChanged(String text, WidgetRef ref) {
    if (text.length != 7) {
      return;
    }

    try {
      int.parse(text);
      ref.watch(postalCodeProvider.state).state = text;
      print(text);
    } catch (ex) {}
  }
}
