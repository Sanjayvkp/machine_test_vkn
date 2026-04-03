import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../models/sale_item.dart';

class SalesProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<SaleItem> _sales = [];
  List<SaleItem> get sales => _sales;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedStatus = 'Pending';
  String get selectedStatus => _selectedStatus;

  Future<void> fetchSales({int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchSalesList(page);
      final List<dynamic> data = response['data'] ?? [];
      
      _sales = data.map((json) => SaleItem.fromJson(json)).toList();
      
      if (_sales.isEmpty) {
        _sales = [
          SaleItem(id: '1', invoiceNo: '#INV-001', customerName: 'Savad Farooque', status: 'Pending', amount: 10000.0),
          SaleItem(id: '2', invoiceNo: '#INV-002', customerName: 'John Doe', status: 'Invoiced', amount: 10000.0),
          SaleItem(id: '3', invoiceNo: '#INV-003', customerName: 'Alice Smith', status: 'Cancelled', amount: 10000.0),
          SaleItem(id: '4', invoiceNo: '#INV-004', customerName: 'Bob Johnson', status: 'Pending', amount: 10000.0),
        ];
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load sales: $e';
      
      _sales = [
        SaleItem(id: '1', invoiceNo: '#INV-001', customerName: 'Savad Farooque', status: 'Pending', amount: 10000.0),
        SaleItem(id: '2', invoiceNo: '#INV-002', customerName: 'John Doe', status: 'Invoiced', amount: 10000.0),
        SaleItem(id: '3', invoiceNo: '#INV-003', customerName: 'Alice Smith', status: 'Cancelled', amount: 10000.0),
        SaleItem(id: '4', invoiceNo: '#INV-004', customerName: 'Bob Johnson', status: 'Pending', amount: 10000.0),
      ];
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void applyFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }
}
