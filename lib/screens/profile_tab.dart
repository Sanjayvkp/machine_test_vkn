import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_text.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  void _handleLogout() async {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Provider.of<UserProvider>(context, listen: false).clearUser();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return Container(
            color: AppColors.black,
            child: Shimmer.fromColors(
              baseColor: AppColors.grey900,
              highlightColor: AppColors.grey800,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.white,
                  ),
                  const SizedBox(height: 16),
                  Container(width: 120, height: 20, color: AppColors.white),
                  const SizedBox(height: 8),
                  Container(width: 180, height: 16, color: AppColors.white),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 4,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final name = userProvider.name ?? 'User';
        final email = userProvider.email ?? 'user@example.com';
        final avatarUrl = userProvider.profileImageUrl;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 16,
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.grey300,
                                backgroundImage: avatarUrl != null
                                    ? NetworkImage(avatarUrl)
                                    : null,
                                child: avatarUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        color: AppColors.grey,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: name,
                                  type: TextType.subheading,
                                  fontWeight: FontWeight.w500,
                                ),
                                CustomText(
                                  text: email,
                                  type: TextType.caption,
                                  color: AppColors.lightBlueAccent,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/icons/settings_icon_profile_edit.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              iconWidget: SvgPicture.asset(
                                'assets/icons/settings_icon_rides.svg',
                                width: 24,
                              ),
                              title: '4.3 ★',
                              subtitle: '2,211 rides',
                              bgColor: AppColors.blueLight,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              iconWidget: SvgPicture.asset(
                                'assets/icons/settings_icon_kyc.svg',
                                width: 24,
                              ),
                              title: 'KYC',
                              subtitle: 'Verified',
                              customContent: Row(
                                children: [
                                  CustomText(
                                    text: 'KYC',
                                    type: TextType.subheading,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: AppColors.white,
                                    size: 10,
                                  ),
                                ],
                              ),
                              bgColor: AppColors.tealLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: OutlinedButton.icon(
                          onPressed: _handleLogout,
                          icon: SvgPicture.asset(
                            'assets/icons/settings_icon_logout.svg',
                            colorFilter: const ColorFilter.mode(
                              AppColors.redText,
                              BlendMode.srcIn,
                            ),
                            width: 20,
                          ),
                          label: CustomText(
                            text: 'Logout',
                            type: TextType.button,
                            color: AppColors.redText,
                            fontWeight: FontWeight.w400,
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.white10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildMenuItem('assets/icons/settings_icon_help.svg', 'Help'),
                _buildMenuItem('assets/icons/settings_icon_faq.svg', 'FAQ'),
                _buildMenuItem(
                  'assets/icons/settings_icon_invite_friends.svg',
                  'Invite Friends',
                ),
                _buildMenuItem(
                  'assets/icons/settings_icon_terms_service.svg',
                  'Terms of service',
                ),
                _buildMenuItem(
                  'assets/icons/settings_icon_privacy_policy.svg',
                  'Privacy Policy',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required Widget iconWidget,
    String? title,
    required String subtitle,
    required Color bgColor,
    Widget? customContent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 24),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: iconWidget,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customContent ??
                    CustomText(
                      text: title ?? '',
                      type: TextType.subheading,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                const SizedBox(height: 4),
                CustomText(
                  text: subtitle,
                  type: TextType.caption,
                  color: AppColors.subtitleGrey,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String assetPath, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: SvgPicture.asset(
        assetPath,
        colorFilter: const ColorFilter.mode(
          AppColors.blueLight,
          BlendMode.srcIn,
        ),
        width: 20,
      ),
      title: CustomText(
        text: title,
        type: TextType.button,
        fontWeight: FontWeight.w400,
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.white54),
      onTap: () {},
    );
  }
}
