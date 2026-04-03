import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_colors.dart';

class CustomBottomNavItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final String label;

  const CustomBottomNavItem({
    super.key,
    required this.iconPath,
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 4),
        if (isSelected)
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
