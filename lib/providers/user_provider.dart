import 'package:flutter/material.dart';

class UserModel {
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
  final String? phone;
  final Map<String, dynamic>? customerData;
  final Map<String, dynamic>? data;

  UserModel({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImageUrl,
    this.phone,
    this.customerData,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final customerData = json['customer_data'] ?? {};

    final firstName = data['first_name'] ?? '';
    final lastName = data['last_name'] ?? '';
    final name = firstName.isNotEmpty && lastName.isNotEmpty
        ? '$firstName $lastName'
        : (data['name'] ?? '');

    return UserModel(
      name: name,
      firstName: firstName,
      lastName: lastName,
      email: data['email'],
      profileImageUrl: customerData['photo'],
      phone: data['phone'] ?? customerData['phone'],
      customerData: customerData,
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_image_url': profileImageUrl,
      'phone': phone,
      'customer_data': customerData,
      'data': data,
    };
  }
}

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? get name => _user?.name;
  String? get firstName => _user?.firstName;
  String? get lastName => _user?.lastName;
  String? get email => _user?.email;
  String? get profileImageUrl => _user?.profileImageUrl;
  String? get phone => _user?.phone;
  Map<String, dynamic>? get customerData => _user?.customerData;
  Map<String, dynamic>? get userData => _user?.data;

  void setUser(UserModel user) {
    _user = user;
    _errorMessage = null;
    notifyListeners();
  }

  void setUserFromJson(Map<String, dynamic> json) {
    _user = UserModel.fromJson(json);
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  clearUser() {
    _user = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  bool get isLoggedIn => _user != null;
}
