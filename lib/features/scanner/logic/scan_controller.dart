// lib/features/scanner/logic/scan_controller.dart

import 'package:flutter/material.dart';

class ScanController with ChangeNotifier {
  // Placeholder for future logic separation
  bool isScanning = false;

  void startScanning() {
    isScanning = true;
    notifyListeners();
  }

  void stopScanning() {
    isScanning = false;
    notifyListeners();
  }
}