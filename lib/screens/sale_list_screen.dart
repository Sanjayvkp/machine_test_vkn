import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_colors.dart';
import '../providers/sales_provider.dart';
import '../widgets/custom_text.dart';
import 'filter_screen.dart';

class SaleListScreen extends StatefulWidget {
  const SaleListScreen({super.key});

  @override
  State<SaleListScreen> createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SalesProvider>(context, listen: false);
      provider.setSearchQuery('');
      provider.fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: CustomText(
            text: 'Invoices',
            type: TextType.subheading,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: Column(
          children: [
            const Divider(color: Colors.white10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101B26),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icon_invoice_search.svg',
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF8A8A8A),
                              BlendMode.srcIn,
                            ),
                            width: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                Provider.of<SalesProvider>(
                                  context,
                                  listen: false,
                                ).setSearchQuery(val);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FilterScreen()),
                      );
                    },
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.containerDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icon_invoice_filter.svg',
                            colorFilter: const ColorFilter.mode(
                              AppColors.primaryBlue,
                              BlendMode.srcIn,
                            ),
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            text: 'Add Filters',
                            type: TextType.button,
                            color: AppColors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10),
            Expanded(
              child: Consumer<SalesProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[900]!,
                      highlightColor: Colors.grey[800]!,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 6,
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 12.0,
                          ),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final list = provider.sales.where((item) {
                    return item.customerName.toLowerCase().contains(
                          provider.searchQuery.toLowerCase(),
                        ) ||
                        item.invoiceNo.toLowerCase().contains(
                          provider.searchQuery.toLowerCase(),
                        );
                  }).toList();

                  if (list.isEmpty) {
                    return const Center(
                      child: CustomText(
                        text: 'No invoices found.',
                        type: TextType.body,
                        color: AppColors.textSecondary,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.white10),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      Color statusColor = AppColors.pendingColor;
                      if (item.status == 'Invoiced') {
                        statusColor = AppColors.invoicedColor;
                      }
                      if (item.status == 'Cancelled') {
                        statusColor = AppColors.textSecondary;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: item.invoiceNo,
                                  type: TextType.body,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                                CustomText(
                                  text: item.status,
                                  type: TextType.caption,
                                  color: statusColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: item.customerName,
                                  type: TextType.body,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      text: 'SAR. ',
                                      type: TextType.body,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textSecondary,
                                    ),
                                    CustomText(
                                      text: item.amount.toStringAsFixed(2),
                                      type: TextType.body,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
