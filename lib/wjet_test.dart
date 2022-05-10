import 'dart:convert';
import 'dart:ffi';

import 'package:dll_test/main.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

class WJetTestScreen extends StatelessWidget {
  WJetTestScreen({Key? key}) : super(key: key);
  // late void Function() getAll;
  // late void Function() getTypes;
  late Utf8 getString;
  late int Function() getLength = openDll
      .lookup<NativeFunction<Int32 Function()>>('GetEC_Length')
      .asFunction();
  late double Function(int idx) getECValue = openDll
      .lookup<NativeFunction<Double Function(Int32)>>('GetEC_DValue')
      .asFunction();
  // late Pointer<Int32> Function(int a) pointerTest = openDll
  //     .lookup<NativeFunction<Pointer<Int32> Function(Int32)>>('Get_Test')
  //     .asFunction();

  // final Pointer<Utf8> Function() ptr = openDll
  //     .lookup<NativeFunction<Pointer<Utf8> Function()>>("Get_StrPtr")
  //     .asFunction();

  // final Pointer<Utf8> Function() arrayPtr = openDll
  //     .lookup<NativeFunction<Pointer<Utf8> Function()>>("Get_ArrPtr")
  //     .asFunction();

  // final Pointer<Pointer<Utf8>> Function() ppTest = openDll
  //     .lookup<NativeFunction<Pointer<Pointer<Utf8>> Function()>>("Get_StrPtr")
  //     .asFunction();

  final Pointer<Pointer<Utf8>> Function() getTypes = openDll
      .lookup<NativeFunction<Pointer<Pointer<Utf8>> Function()>>("GetEC_Types")
      .asFunction();

  final Pointer<Pointer<Utf8>> Function() getNames = openDll
      .lookup<NativeFunction<Pointer<Pointer<Utf8>> Function()>>("GetEC_Names")
      .asFunction();
  final Pointer<Pointer<Double>> Function() getValues = openDll
      .lookup<NativeFunction<Pointer<Pointer<Double>> Function()>>(
          "GetEC_Values")
      .asFunction();

  late Pointer<Opaque> efe;

  Future<bool> test() async {
    try {
      getTest = openDll
          .lookup<NativeFunction<Pointer<Double> Function()>>("GetSV_DValue")
          .asFunction();
      print('getNum ?? ${getTest.call()}');
      Pointer<Double> test = nullptr;
      test = getTest();
      Pointer.fromAddress(21234);
      // print('pasing data : ${double.parse(test[0].toStringAsFixed(0))}');
      print('pasing data : ${test[0].toStringAsFixed(0)}');

      return true;
    } catch (e) {
      print('dll init error $e');
      return false;
    }
  }

  // List<double> list() {
  //   try {
  //     List<double> values = [];
  //     for (var i = 0; i < getLength(); i++) {
  //       values.add(getECValue(i));
  //     }
  //     return values;
  //   } catch (e) {
  //     return [];
  //   }
  // }
  Pointer<Pointer<Utf8>> strListToPointer(List<String> strings) {
    List<Pointer<Utf8>> utf8PointerList =
        strings.map((str) => str.toNativeUtf8()).toList();

    final Pointer<Pointer<Utf8>> pointerPointer =
        malloc.allocate(utf8PointerList.length);

    strings.asMap().forEach((index, utf) {
      pointerPointer[index] = utf8PointerList[index];
    });

    return pointerPointer;
  }

  Future<bool> pointerPointer() async {
    try {
      final Pointer<Pointer<Utf8>> Function() ppTest = openDll
          .lookup<NativeFunction<Pointer<Pointer<Utf8>> Function()>>(
              "Get_StrPtr")
          .asFunction();

      return true;
    } catch (e) {
      print('dll init error $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              OutlinedButton(
                  onPressed: () {
                    openDll;
                  },
                  child: Text('WJet dll test')),
              OutlinedButton(
                  onPressed: () {
                    int test = getLength();
                    // print(test);
                  },
                  child: Text('get Length')),
              OutlinedButton(
                  onPressed: () {
                    double test = getECValue(6);
                    print(test);
                  },
                  child: Text('get EC Value')),
              // OutlinedButton(
              //     onPressed: () {
              //       openDll;
              //       ptr();
              //       print(ptr().address);
              //       print(
              //           'value : ${Pointer<Utf8>.fromAddress(ptr().address).toDartString()}');
              //     },
              //     child: Text('get Utf-8')),
              // OutlinedButton(
              //     onPressed: () {
              //       int firstAdd =
              //           Pointer<Pointer<Utf8>>.fromAddress(ppTest().address)
              //               .value
              //               .address;

              //       String val =
              //           Pointer<Utf8>.fromAddress(firstAdd).toDartString();
              //       print('value ? ${val}');
              //       List<Pointer<Utf8>> ttt = [];
              //       Pointer<Pointer<Utf8>> aqaq = ppTest();
              //       List<String> qwqw = [];
              //       for (var i = 0; i < 5; i++) {
              //         aqaq[i];
              //         qwqw.add(Pointer<Utf8>.fromAddress(aqaq[i].address)
              //             .toDartString());
              //       }
              //       print(qwqw);
              //     },
              //     child: Text('pointer pointer')),
              // OutlinedButton(
              //     onPressed: () {
              //       print(arrayPtr().address);
              //       Pointer<Utf8> testPtr = nullptr;
              //       testPtr = arrayPtr();
              //     },
              //     child: Text('get Utf-8 Array')),
              SizedBox(
                height: 300,
                width: 500,
                child: ListView(
                  children: List.generate(
                    getLength(),
                    (index) => Container(
                      color: Colors.amber,
                      // child: Text(list()[index].toString()),
                      child: Text('data'),
                    ),
                  ),
                ),
              )
            ],
          ),
          OutlinedButton(
              onPressed: () {
                Pointer<Pointer<Utf8>> aqaq = getTypes();
                List<String> qwqw = [];
                for (var i = 0; i < getLength(); i++) {
                  aqaq[i];
                  qwqw.add(Pointer<Utf8>.fromAddress(aqaq[i].address)
                      .toDartString());
                }
                print(qwqw);
              },
              child: const Text('Get types')),
          OutlinedButton(
              onPressed: () {
                List<String> qwqw = [];
                for (var i = 0; i < getLength(); i++) {
                  qwqw.add(Pointer<Utf8>.fromAddress(getNames()[i].address)
                      .toDartString());
                }
                print(qwqw);
              },
              child: const Text('Get Names')),
          OutlinedButton(
              onPressed: () {
                Pointer<Pointer<Double>> aqaq = getValues();
                List qwqw = [];
                for (var i = 0; i < getLength(); i++) {
                  aqaq[i];
                  // qwqw.add(Pointer<Double>.fromAddress(aqaq[i].address)
                  //     .asTypedList(getLength())[i]
                  //     .toDouble());
                  // print(Pointer<Double>.fromAddress(aqaq[i].address).cast());
                  qwqw.add(Pointer<Double>.fromAddress(aqaq[i].address).value);
                }
                print(qwqw);
              },
              child: const Text('Get Values')),
        ],
      ),
    );
  }
}
