import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import '../../presentation/theme/app_theme.dart';
import '../../presentation/widgets/pill_preview_widget.dart';

class PillMatcherViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  // State
  PillShape _selectedShape = PillShape.capsule;
  PillShape get selectedShape => _selectedShape;

  Color _selectedColor = AppColors.primary;
  Color get selectedColor => _selectedColor;

  PillTexture _selectedTexture = PillTexture.solid;
  PillTexture get selectedTexture => _selectedTexture;

  bool _isAnalyzing = false;
  bool get isAnalyzing => _isAnalyzing;

  // Preset colors for UI
  final List<Color> presetColors = [
    AppColors.primary,
    const Color(0xFFFF4B4B),
    const Color(0xFF00D084),
    const Color(0xFFFF9F00),
    const Color(0xFF7B61FF),
    Colors.white,
    Colors.grey,
  ];

  // Setters
  void setShape(PillShape shape) {
    _selectedShape = shape;
    notifyListeners();
  }

  void setColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setTexture(PillTexture texture) {
    _selectedTexture = texture;
    notifyListeners();
  }

  Future<void> scanPill() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        await _analyzeImage(image.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      // In a real app, handle permission errors etc
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _analyzeImage(image.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _analyzeImage(String path) async {
    _isAnalyzing = true;
    notifyListeners();

    // SImulate AI Analysis delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock "Analysis Result" - randomizing for demo effect
    // In a real app, this would send image to backend
    final random = Random();
    _selectedShape = PillShape.values[random.nextInt(PillShape.values.length)];
    _selectedColor = presetColors[random.nextInt(presetColors.length)];
    _selectedTexture =
        PillTexture.values[random.nextInt(PillTexture.values.length)];

    _isAnalyzing = false;
    notifyListeners();
  }
}
