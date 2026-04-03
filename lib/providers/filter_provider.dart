import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _selectedPeriod = 'This Month';
  String _selectedStatus = 'Pending';
  String _startDate = '';
  String _endDate = '';
  bool _isCustomerDropdownOpen = false;
  final List<String> _selectedCustomers = [];

  // Getters
  String get selectedPeriod => _selectedPeriod;
  String get selectedStatus => _selectedStatus;
  String get startDate => _startDate;
  String get endDate => _endDate;
  bool get isCustomerDropdownOpen => _isCustomerDropdownOpen;
  List<String> get selectedCustomers => List.unmodifiable(_selectedCustomers);

  // Batch update method
  void updatePeriodAndDates(String period, String start, String end) {
    _selectedPeriod = period;
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  // Setters
  void setSelectedPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setSelectedStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void updateDates(String start, String end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void toggleCustomerDropdown() {
    _isCustomerDropdownOpen = !_isCustomerDropdownOpen;
    notifyListeners();
  }

  void setCustomerDropdownOpen(bool isOpen) {
    _isCustomerDropdownOpen = isOpen;
    notifyListeners();
  }

  void addCustomer(String customer) {
    _selectedCustomers.add(customer);
    notifyListeners();
  }

  void removeCustomer(String customer) {
    _selectedCustomers.remove(customer);
    notifyListeners();
  }

  void clearCustomers() {
    _selectedCustomers.clear();
    notifyListeners();
  }
}
