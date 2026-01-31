import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class FoodOrderService {
  
  static Future<void> orderOnZomato(String dishName) async {
    // 1. Clean the dish name (remove generic words for better search results)
    final cleanName = _cleanDishName(dishName);
    final encodedQuery = Uri.encodeComponent(cleanName);
    
    // Zomato App Deep Link
    final Uri appUri = Uri.parse("zomato://search?q=$encodedQuery");
    
    // Zomato Web Fallback
    final Uri webUri = Uri.parse("https://www.zomato.com/search?q=$encodedQuery");

    try {
      // Try to launch the App first
      if (await canLaunchUrl(appUri)) {
        await launchUrl(
          appUri, 
          mode: LaunchMode.externalApplication, // Forces external app
        );
      } else {
        // If app not installed, open browser
        await launchUrl(
          webUri, 
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print("Error launching Zomato: $e");
    }
  }

  static Future<void> orderOnSwiggy(String dishName) async {
    final cleanName = _cleanDishName(dishName);
    final encodedQuery = Uri.encodeComponent(cleanName);
    
    // Swiggy App Deep Link
    // Note: Swiggy's scheme varies slightly by version, this is the most reliable one
    final Uri appUri = Uri.parse("swiggy://explore?query=$encodedQuery");
    
    // Swiggy Web Fallback
    final Uri webUri = Uri.parse("https://www.swiggy.com/search?query=$encodedQuery");

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(
          appUri, 
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(
          webUri, 
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print("Error launching Swiggy: $e");
    }
  }

  // Helper to remove words that confuse the search
  static String _cleanDishName(String name) {
    // Example: "Healthy Oatmeal Bowl" -> "Oatmeal Bowl"
    // Search engines work better with simpler terms
    return name
      .replaceAll('Healthy', '')
      .replaceAll('Low-Calorie', '')
      .replaceAll('Homemade', '')
      .trim();
  }
}