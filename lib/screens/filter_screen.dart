import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/sales_provider.dart';
import '../providers/filter_provider.dart';
import '../widgets/custom_text.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<String> _dummyCustomers = [
    "savad farooque",
    "John Doe",
    "Alice Smith",
    "Cash In Hand",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final today =
          "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
      context.read<FilterProvider>().updateDates(today, today);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: CustomText(
              text: 'Filters',
              type: TextType.subheading,
              fontWeight: FontWeight.w500,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                onPressed: () {},
              ),
              TextButton(
                onPressed: () {
                  Provider.of<SalesProvider>(
                    context,
                    listen: false,
                  ).applyFilter(filterProvider.selectedStatus);
                  Navigator.pop(context);
                },
                child: CustomText(
                  text: 'Filter',
                  type: TextType.button,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(color: Colors.white10),
                const SizedBox(height: 16),

                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackgroundDark,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: DropdownButton<String>(
                      value: filterProvider.selectedPeriod,
                      padding: const EdgeInsets.all(0),
                      underline: const SizedBox(),
                      dropdownColor: AppColors.inputBackgroundDark,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.white70,
                      ),
                      items:
                          ['This Week', 'This Month', 'Last Month', 'This Year']
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: CustomText(
                                    text: e,
                                    type: TextType.body,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          Future.delayed(Duration.zero, () {
                            if (!mounted) return;
                            final filterProvider = Provider.of<FilterProvider>(
                              context,
                              listen: false,
                            );
                            final now = DateTime.now();
                            DateTime start;
                            DateTime end = now;

                            if (val == 'This Month') {
                              start = DateTime(now.year, now.month, 1);
                            } else if (val == 'Last Month') {
                              start = DateTime(now.year, now.month - 1, 1);
                              end = DateTime(now.year, now.month, 0);
                            } else if (val == 'This Year') {
                              start = DateTime(now.year, 1, 1);
                              end = DateTime(now.year, 12, 31);
                            } else if (val == 'This Week') {
                              start = now.subtract(
                                Duration(days: now.weekday - 1),
                              );
                            } else {
                              start = now;
                            }

                            if (end.isAfter(now)) {
                              end = now;
                            }

                            final String startFormat =
                                "${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}";
                            final String endFormat =
                                "${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}";

                            filterProvider.updatePeriodAndDates(
                              val,
                              startFormat,
                              endFormat,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDateChip(filterProvider.startDate, true),
                    const SizedBox(width: 16),
                    _buildDateChip(filterProvider.endDate, false),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(color: Colors.white10),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusChip('Pending', filterProvider),
                    _buildStatusChip('Invoiced', filterProvider),
                    _buildStatusChip('Cancelled', filterProvider),
                  ],
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Future.delayed(Duration.zero, () {
                          if (!mounted) return;
                          filterProvider.toggleCustomerDropdown();
                        }),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.inputBackgroundDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Customer',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              Icon(
                                filterProvider.isCustomerDropdownOpen
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white54,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (filterProvider.isCustomerDropdownOpen)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.inputBackgroundDark,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Customers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ..._dummyCustomers.map(
                                (customer) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => Future.delayed(
                                      Duration.zero,
                                      () {
                                        if (!mounted) return;
                                        if (filterProvider.selectedCustomers
                                            .contains(customer)) {
                                          filterProvider.removeCustomer(
                                            customer,
                                          );
                                        } else {
                                          filterProvider.addCustomer(customer);
                                        }
                                      },
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            filterProvider.selectedCustomers
                                                .contains(customer)
                                            ? AppColors.primaryBlue.withOpacity(
                                                0.2,
                                              )
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color:
                                              filterProvider.selectedCustomers
                                                  .contains(customer)
                                              ? AppColors.primaryBlue
                                              : Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            filterProvider.selectedCustomers
                                                    .contains(customer)
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color:
                                                filterProvider.selectedCustomers
                                                    .contains(customer)
                                                ? AppColors.primaryBlue
                                                : Colors.white54,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              customer,
                                              style: TextStyle(
                                                color:
                                                    filterProvider
                                                        .selectedCustomers
                                                        .contains(customer)
                                                    ? Colors.white
                                                    : Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Future.delayed(Duration.zero, () {
                                          if (!mounted) return;
                                          filterProvider
                                              .setCustomerDropdownOpen(false);
                                        }),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: Divider(
                    color: const Color.fromARGB(26, 177, 177, 177),
                  ),
                ),
                const SizedBox(height: 16),

                if (filterProvider.selectedCustomers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: filterProvider.selectedCustomers
                            .map(
                              (c) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.containerDark,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      c,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () =>
                                          Future.delayed(Duration.zero, () {
                                            if (!mounted) return;
                                            filterProvider.removeCustomer(c);
                                          }),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Color(0xFF0A9EF3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateChip(String date, bool isStart) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primaryBlue,
                  onPrimary: Colors.white,
                  surface: AppColors.surfaceColor,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && mounted) {
          final now = DateTime.now();
          final selectedDate = picked.isAfter(now) ? now : picked;
          final formatted =
              "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";

          final filterProvider = context.read<FilterProvider>();
          if (isStart) {
            filterProvider.updateDates(formatted, filterProvider.endDate);
          } else {
            filterProvider.updateDates(filterProvider.startDate, formatted);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.inputBackgroundDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(date, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, FilterProvider filterProvider) {
    final isSelected = filterProvider.selectedStatus == label;
    return GestureDetector(
      onTap: () => Future.delayed(Duration.zero, () {
        if (!mounted) return;
        filterProvider.setSelectedStatus(label);
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : const Color(0xFF1B2B30),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
