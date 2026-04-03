import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../core/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SecureStorage _storage = SecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);
      
      if (response['success'] == 6000 || response['data'] != null) {
        final data = response['data'];
        final token = data['access'];
        final userId = data['user_id']; 

        await _storage.saveSession(token, userId);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response['error'] ?? 'Login failed.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Invalid credentials or network issue.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.clearSession();
    notifyListeners();
  }
}
