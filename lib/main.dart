import 'dart:ffi';
import 'package:flutter/material.dart';

final DynamicLibrary wjetTest = DynamicLibrary.open("Wjet_Test.dll");
late Pointer<Double> Function() getNum;

void main() async {
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

    // next = fibonacci.lookup<NativeFunction<Bool Function>>(symbolName)
    // next = fibonacci
    //     .lookup<NativeFunction<Bool Function()>>('fibonacci_next')
    //     .asFunction<bool Function()>();
    // current = fibonacci
    //     .lookup<NativeFunction<Int8 Function()>>('fibonacci_current')
    //     .asFunction<int Function()>();
    // next;
    // current;
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
