import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrentryapp/services/http_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const QRScanner(),
    );
  }
}

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey key = GlobalKey(debugLabel: 'QR');
  String result = '';
  bool hasNavigated = false;
  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
    super.reassemble();
  }
  late QRViewController controller;
  onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        debugPrint(event.code);
        if (event.code != null && event.code?.isEmpty == false) {
          result = event.code!;
          if (!hasNavigated) {
            hasNavigated = true;
            Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => QRResultScreen(code: result)
            )
          );
          }
        }
      });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white38,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QRView(
                    key: key,
                    onQRViewCreated: onQRViewCreated
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: Colors.lightBlueAccent,
                        width: 2
                      )
                    ),
                    width: MediaQuery.of(context).size.width/1.5,
                    height: MediaQuery.of(context).size.width/1.5,
                    child: Lottie.asset('assets/lf20_uuqizene.json')
                  )
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 3,
            child: Center(
              child: Text(
                'Scanning', style: TextStyle(
                  fontSize: 23,
                  color: Colors.blue
                ),
            )),
          )
        ],
      ),
    );
  }
}

class QRResultScreen extends StatefulWidget {
  final String code;
  const QRResultScreen({super.key, required this.code});
  @override
  State<QRResultScreen> createState() => _QRResultScreenState();
}

class _QRResultScreenState extends State<QRResultScreen> {
  Future<void> initialize() async {
    await HttpServices.postYourNudes('approve', body: {
      'token': widget.code
    }).then((result) {
      print(result);
    }).catchError((err) {
      debugPrint(err.toString());
    });
  }
  @override
  void initState() {
    initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.code)
        ]
      ),
    );
  }
}