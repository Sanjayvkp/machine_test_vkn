import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/api_service.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_text.dart';
import 'sale_list_screen.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  DateTime _selectedDate = DateTime.now();
  int _selectedDay = DateTime.now().day;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setLoading(true);

      final profile = await _apiService.fetchUserProfile();
      userProvider.setUserFromJson(profile);
      userProvider.setLoading(false);
    } catch (e) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setError('Failed to load profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                const SizedBox(height: 24),
                _buildRevenueCard(),
                const SizedBox(height: 16),
                _buildStatCard(
                  title: 'Bookings',
                  value: '123',
                  subtitle: 'Reserved',
                  iconPath: 'assets/icons/icon_home_bookings.svg',
                  iconColor: const Color(0xFF28635B),
                  iconBgColor: Colors.white,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  title: 'Invoices',
                  value: '10,232.00',
                  subtitle: 'Rupees',
                  iconPath: 'assets/icons/icon_home_invoices.svg',
                  iconColor: const Color(0xFF28635B),
                  iconBgColor: const Color(0xFFC8E6D3),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SaleListScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/icon_company_logo.svg',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 8),
                CustomText(
                  text: 'CabZing',
                  type: TextType.subheading,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: userProvider.profileImageUrl != null
                  ? NetworkImage(userProvider.profileImageUrl!)
                  : null,
              child: userProvider.profileImageUrl == null
                  ? const Icon(Icons.person, color: AppColors.grey)
                  : null,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: 'SAR',
                        type: TextType.body,
                        color: AppColors.white54,
                        fontWeight: FontWeight.w400,
                      ),
                      CustomText(
                        text: ' 2,78,000.00',
                        type: TextType.body,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: '+21% ',
                        type: TextType.caption,
                        color: AppColors.greenText,
                      ),
                      CustomText(
                        text: 'than last month.',
                        type: TextType.caption,
                        color: AppColors.white54,
                      ),
                    ],
                  ),
                ],
              ),
              CustomText(text: 'Revenue', type: TextType.body, fontSize: 16),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.white10, strokeWidth: 1),
                  getDrawingVerticalLine: (value) =>
                      FlLine(color: Colors.transparent, strokeWidth: 0),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value == 1 ||
                            value == 2 ||
                            value == 3 ||
                            value == 4) {
                          return CustomText(
                            text: '${value.toInt()}K',
                            type: TextType.caption,
                            color: AppColors.white54,
                          );
                        }
                        return const CustomText(text: '');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getGraphDataForSelectedDate(),
                    isCurved: true,
                    color: AppColors.tealGradient,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.tealGradient.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDateSelector(),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required String iconPath,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              height: 90,
              width: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: title, type: TextType.body, fontSize: 14),
                  CustomText(
                    text: value,
                    type: TextType.subheading,
                    fontWeight: FontWeight.w400,
                  ),
                  CustomText(
                    text: subtitle,
                    type: TextType.caption,
                    color: AppColors.white40,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.greyDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _selectDate(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomText(
              text:
                  '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
              type: TextType.body,
              color: AppColors.white80,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _generateDateButtons(),
        ),
      ],
    );
  }

  List<Widget> _generateDateButtons() {
    final List<Widget> buttons = [];
    final daysInMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
      0,
    ).day;

    int startDay = (_selectedDay - 3).clamp(1, daysInMonth);
    int endDay = (startDay + 6).clamp(startDay, daysInMonth);

    if (endDay > daysInMonth) {
      endDay = daysInMonth;
      startDay = (endDay - 6).clamp(1, daysInMonth);
    }

    for (int i = 0; i < 7; i++) {
      final day = startDay + i;
      if (day <= daysInMonth) {
        final isSelected = day == _selectedDay;
        buttons.add(
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = day;
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDay,
                );
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: CustomText(
                text: day.toString().padLeft(2, '0'),
                type: TextType.body,
                color: isSelected ? AppColors.white : AppColors.white80,
                fontSize: 14,
              ),
            ),
          ),
        );
      }
    }

    return buttons;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedDay = picked.day;
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  List<FlSpot> _getGraphDataForSelectedDate() {
    final baseData = [1.5, 2.0, 1.8, 2.5, 2.2, 3.0, 2.8, 3.2, 2.9, 3.5, 3.0];

    final offset = (_selectedDay - 1) * 0.1;
    return List.generate(11, (index) {
      return FlSpot(
        index.toDouble(),
        (baseData[index] + offset).clamp(1.0, 4.0),
      );
    });
  }
}
