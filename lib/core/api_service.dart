import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';

class ApiService {
  static const String loginUrl = 'https://api.accounts.vikncodes.com/api/v1/users/login';
  static const String salesListUrl = 'https://api.viknbooks.com/api/v10/sales/sale-list-page/';
  
  static String userProfileUrl(int userId) {
    return 'https://api.viknbooks.com/api/v10/users/user-view/$userId/';
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      log('--- API Request: LOGIN ---');
      log('URL: $loginUrl');
      final bodyPayload = jsonEncode({
          'username': username,
          'password': password,
          'is_mobile': true,
      });
      log('Body: $bodyPayload');
      
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: bodyPayload,
      );

      log('--- API Response: LOGIN ---');
      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error during login: $e');
    }
  }

  Future<Map<String, dynamic>> fetchSalesList(int pageNo) async {
    final storage = SecureStorage();
    final token = await storage.getToken();
    final userId = await storage.getUserId();

    if (token == null || userId == null) {
      throw Exception('Unauthorized');
    }

    try {
      log('--- API Request: FETCH SALES LIST ---');
      log('URL: $salesListUrl');
      final bodyPayload = jsonEncode({
          "BranchID": 1,
          "CompanyID": "1901b825-fe6f-418d-b5f0-7223d0040d08",
          "CreatedUserID": userId,
          "PriceRounding": 2,
          "page_no": pageNo,
          "items_per_page": 10,
          "type": "Sales",
          "WarehouseID": 1,
      });
      log('Headers: Authorization: Bearer $token');
      log('Body: $bodyPayload');

      final response = await http.post(
        Uri.parse(salesListUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: bodyPayload,
      );

      log('--- API Response: FETCH SALES LIST ---');
      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch sales list');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final storage = SecureStorage();
    final token = await storage.getToken();
    final userId = await storage.getUserId();

    if (token == null || userId == null) {
      throw Exception('Unauthorized');
    }

    try {
      final url = userProfileUrl(userId);
      log('--- API Request: USER PROFILE ---');
      log('URL: $url');
      log('Headers: Authorization: Bearer $token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log('--- API Response: USER PROFILE ---');
      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
