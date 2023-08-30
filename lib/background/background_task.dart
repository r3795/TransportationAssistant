import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
void startBackgroundIsolate() async {
  // 백그라운드에서 isolate 메세지를 수신하기 위한 포트 만들기
  ReceivePort receivePort = ReceivePort();

  // 백그라운드 isolate 생성
  await Isolate.spawn(backgroundTask, receivePort.sendPort);

  // 백그라운드 isolate로부터 메세지 수신
  receivePort.listen((message) {
    if (message is String) {
      //메세지 받은 거 처리하기
      print('Received message from background isolate: $message');
    }
  });
}
void backgroundTask(SendPort sendPort) {
  // Perform your background processing here
  for (int i = 0; i < 10; i++) {
    // Simulate some work
    sleep(Duration(seconds: 1));

    // Send a message to the main UI isolate
    sendPort.send('Background task progress: $i');
  }
}