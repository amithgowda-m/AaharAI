// lib/features/scanner/presentation/camera_screen.dart - REPLACE ENTIRE FILE

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../services/ai_food_service.dart';
import 'food_result_sheet.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isLoading = false;
  final AiFoodService _aiService = AiFoodService();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    
    _controller = CameraController(
      cameras[0], 
      ResolutionPreset.medium, 
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid 
          ? ImageFormatGroup.jpeg 
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _controller!.initialize();
      await _controller!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint("Camera Init Error: $e");
    }

    if (mounted) setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyze() async {
    if (_isLoading || _controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isLoading = true);

    try {
      // Lock Focus & Exposure
      if (_controller!.value.focusPointSupported) {
        await _controller!.setFocusMode(FocusMode.locked);
      }
      if (_controller!.value.exposurePointSupported) {
        await _controller!.setExposureMode(ExposureMode.locked);
      }

      // Take Picture
      final image = await _controller!.takePicture();

      // Unlock Camera
      if (_controller!.value.focusPointSupported) {
        await _controller!.setFocusMode(FocusMode.auto);
      }
      if (_controller!.value.exposurePointSupported) {
        await _controller!.setExposureMode(ExposureMode.auto);
      }

      // Call AI Service
      final result = await _aiService.identifyFood(File(image.path));

      setState(() => _isLoading = false);
      if (!mounted) return;

      // Handle Result
      if (result['is_food'] == true) {
        // IMPORTANT: Close camera first
        Navigator.pop(context);
        
        // Small delay for smooth transition
        await Future.delayed(const Duration(milliseconds: 200));
        
        // Show result sheet on previous screen
        if (mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return FoodResultSheet(
                data: result,
                imagePath: image.path,
              );
            },
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ ${result['reason'] ?? 'Not a valid food item.'}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      try {
        await _controller?.setFocusMode(FocusMode.auto);
        await _controller?.setExposureMode(ExposureMode.auto);
      } catch (_) {}
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Center(child: CameraPreview(_controller!)),
          
          // Instructions Overlay
          if (!_isLoading)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Point camera at food and tap capture',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          
          // Capture Button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isLoading ? null : _captureAndAnalyze,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isLoading ? Colors.grey : Colors.white,
                    border: Border.all(
                      color: _isLoading ? Colors.grey : Colors.white,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: _isLoading 
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 3,
                          ),
                        ) 
                      : const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.black,
                        ),
                ),
              ),
            ),
          ),
          
          // Loading Overlay
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing food...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
