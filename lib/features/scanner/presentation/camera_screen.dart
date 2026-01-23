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
          : ImageFormatGroup.bgra8888, // Better compatibility
    );

    try {
      await _controller!.initialize();
      // Set initial focus mode to auto
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
    // 1. Safety Checks
    if (_isLoading || _controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isLoading = true);

    try {
      // 2. THE FIX: Lock Focus & Exposure before capturing
      // This prevents the "Waiting for focus" loop on Infinix devices
      if (_controller!.value.focusPointSupported) {
        await _controller!.setFocusMode(FocusMode.locked);
      }
      if (_controller!.value.exposurePointSupported) {
        await _controller!.setExposureMode(ExposureMode.locked);
      }

      // 3. Take Picture
      final image = await _controller!.takePicture();

      // 4. Unlock Immediately (Restore Preview)
      if (_controller!.value.focusPointSupported) {
        await _controller!.setFocusMode(FocusMode.auto);
      }
      if (_controller!.value.exposurePointSupported) {
        await _controller!.setExposureMode(ExposureMode.auto);
      }

      // 5. Call AI Service
      final result = await _aiService.identifyFood(File(image.path));

      setState(() => _isLoading = false);
      if (!mounted) return;

      // 6. Handle Result
      if (result['is_food'] == true) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, 
          backgroundColor: Colors.transparent,
          builder: (_) => DraggableScrollableSheet(
            initialChildSize: 0.6, 
            minChildSize: 0.4,
            maxChildSize: 0.9,    
            builder: (_, controller) => SingleChildScrollView(
              controller: controller,
              child: FoodResultSheet(data: result), 
            ),
          ),
        );
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
      // Reset state if anything fails
      setState(() => _isLoading = false);
      // Try to unlock camera even if error occurred
      try {
          await _controller?.setFocusMode(FocusMode.auto);
          await _controller?.setExposureMode(ExposureMode.auto);
      } catch (_) {}
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const Scaffold(backgroundColor: Colors.black);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: CameraPreview(_controller!)),
          
          // Capture Button
          Positioned(
            bottom: 50, left: 0, right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureAndAnalyze,
                child: Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
                    ]
                  ),
                  child: _isLoading 
                    ? const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: Colors.black)) 
                    : const Icon(Icons.camera_alt, size: 40, color: Colors.black),
                ),
              ),
            ),
          ),
          
          // Back Button
          Positioned(
            top: 50, left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}