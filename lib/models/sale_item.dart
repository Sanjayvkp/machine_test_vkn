class SaleItem {
  final String id;
  final String invoiceNo;
  final String customerName;
  final String status;
  final double amount;
  
  SaleItem({
    required this.id,
    required this.invoiceNo,
    required this.customerName,
    required this.status,
    required this.amount,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: json['id']?.toString() ?? '',
      invoiceNo: json['VoucherNo'] ?? '#INV-0000',
      customerName: json['CustomerName'] ?? 'Customer Name',
      status: json['Status'] ?? 'Pending',
      amount: double.tryParse(json['GrandTotal'].toString()) ?? 10000.0,
    );
  }
}
