import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AiDetectionService {
  final String apiKey = 'YOUR_ROBOFLOW_API_KEY';
  final String modelEndpoint = 'YOUR_ROBOFLOW_MODEL_ENDPOINT'; // e.g., 'ocean-waste-v1/1'

  Future<Map<String, dynamic>> detectWaste(File imageFile) async {
    try {
      // 1. Prepare image
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 2. Make Request to Roboflow
      final url = Uri.parse('https://detect.roboflow.com/$modelEndpoint?api_key=$apiKey');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: base64Image,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return parseDetectionResults(data);
      } else {
        throw Exception('Failed to detect waste: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error in AI Detection: $e');
    }
  }

  Map<String, dynamic> parseDetectionResults(Map<String, dynamic> data) {
    final predictions = data['predictions'] as List<dynamic>? ?? [];
    
    List<String> detectedTypes = [];
    double maxConfidence = 0.0;
    int wasteCount = predictions.length;
    List<String> brands = []; // Optional extraction logic if custom model supports brands

    for (var p in predictions) {
      final className = p['class'];
      final confidence = p['confidence'];
      
      if (!detectedTypes.contains(className)) {
        detectedTypes.add(className);
      }
      
      if (confidence > maxConfidence) {
        maxConfidence = confidence;
      }
    }

    // Severity calculation
    String severity = 'Low';
    if (wasteCount > 20 || detectedTypes.contains('Fishing Net')) {
      severity = 'Critical';
    } else if (wasteCount > 10) {
      severity = 'High';
    } else if (wasteCount > 5) {
      severity = 'Medium';
    }

    return {
      'objects': predictions,
      'wasteTypes': detectedTypes,
      'severity': severity,
      'confidence': maxConfidence,
      'count': wasteCount,
      'brands': brands,
    };
  }
}
