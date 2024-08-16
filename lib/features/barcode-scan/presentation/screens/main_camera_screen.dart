import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:reclaim/features/barcode-scan/presentation/screens/providers/transaction_provider.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

class MainCameraScreen extends StatefulWidget {
  static const routeName = '/main-camera-screen';

  const MainCameraScreen({super.key});

  @override
  State<MainCameraScreen> createState() => _MainCameraScreenState();
}

class _MainCameraScreenState extends State<MainCameraScreen> {
  bool isScanning = true; // Variable to control scanning state
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    // Optionally, you can start the camera here
    cameraController.start();
  }

  @override
  void dispose() {
    cameraController.dispose(); // Dispose the controller when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change your color here
        ),
        backgroundColor: custom_colors.primaryBackground,
        elevation: 0,
        title: Text(
          'Scan QR Code',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: custom_colors.primaryBackground,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            height: 520,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: custom_colors.darkGrayVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'Scan the QR Code generated by our machine to earn your rewards.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 400,
                  child: MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      if (!isScanning) return; // Prevent further scans

                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          print(barcode.rawValue ?? "No Data found in QR");
                          setState(() {
                            isScanning = false; // Stop scanning
                          });
                          transactionProvider.createNewTransaction("","",currentUser!.uid, 0,0,0,0,0.0,);
                          Navigator.of(context).pushNamed(
                              '/scan-successful-screen',
                              arguments: barcode.rawValue);
                          break; // Exit the loop after the first successful scan
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
