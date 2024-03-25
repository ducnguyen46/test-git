import 'dart:isolate';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        // useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<int> runHeavyTaskIWithIsolate(int count) async {
  final ReceivePort receivePort = ReceivePort();
  int result = 0;
  try {
    await Isolate.spawn(useIsolate, [receivePort.sendPort, count]);
    result = await receivePort.first;
  } on Object catch (e, stackTrace) {
    debugPrint('Isolate Failed: $e');
    debugPrint('Stack Trace: $stackTrace');
    receivePort.close();
  }
  return result;
}

void useIsolate(List<dynamic> args) {
  SendPort resultPort = args[0];
  int value = 0;
  for (var i = 0; i < args[1]; i++) {
    value += i;
  }
  resultPort.send(value);
}

int runHeavyTaskWithOutIsolate(int count) {
  int value = 0;
  for (var i = 0; i < count; i++) {
    value += i;
  }
  print(value);
  return value;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Without isolate
          int value1 = runHeavyTaskWithOutIsolate(700000000);
          print(value1);

          // With isolate
          // int value2 = await runHeavyTaskIWithIsolate(700000000);
          // print(value2);
        },
        child: const Icon(Icons.numbers),
      ),
    );
  }
}
