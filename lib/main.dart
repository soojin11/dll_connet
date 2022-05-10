import 'dart:ffi';
import 'package:dll_test/wjet_test.dart';
import 'package:flutter/material.dart';

final DynamicLibrary wjetTest = DynamicLibrary.open("Wjet_Test.dll");
final DynamicLibrary openDll = DynamicLibrary.open("WJet.dll");
late Pointer<Double> Function() getNum;
late Pointer<Double> Function() getTest;

void main() async {
  dllInit();
  openDll;
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _dllNext() {
    dllInit();
  }

  void _navi() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WJetTestScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            OutlinedButton(onPressed: _dllNext, child: const Text('dll Next')),
            // Text('${nativeAdd(1, 2)}')
            // Text(current.toString())
            OutlinedButton(
                onPressed: _navi, child: const Text('Wjet dll test')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<bool> dllInit() async {
  try {
    getNum = wjetTest
        .lookup<NativeFunction<Pointer<Double> Function()>>("GetRandomNumber")
        .asFunction();
    print('getNum ?? ${getNum.call()}');
    Pointer<Double> test = nullptr;
    test = getNum();

    print('pasing data : ${double.parse(test[0].toStringAsFixed(0))}');

    return true;
  } catch (e) {
    print('dll init error $e');
    return false;
  }
}
