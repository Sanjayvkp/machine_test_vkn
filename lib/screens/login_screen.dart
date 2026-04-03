import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'Rabeeh@vk');
  final _passwordController = TextEditingController(text: 'Rabeeh@000');
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
              text: authProvider.errorMessage ?? 'Login failed',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF223).withOpacity(0.08),
              Colors.transparent,
              Colors.transparent,
              Color(0xFFFC6BFF).withOpacity(0.05),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.8, -0.3),
              radius: 1.9,
              colors: [Color(0xFFEEF223).withOpacity(0.12), Colors.transparent],
              stops: [0.0, 1.0],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.8, 0.3),
                radius: 1.5,
                colors: [
                  Color(0xFF0A9EF3).withOpacity(0.15),
                  Colors.transparent,
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.6, 0.7),
                  radius: 1,
                  colors: [
                    Color(0xFFFC6BFF).withOpacity(0.15),
                    Colors.transparent,
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/icons/login_icon_language.svg',
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                AppColors.blueAccent,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: CustomText(
                              text: 'English',
                              type: TextType.button,
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                        CustomText(
                          text: 'Login',
                          type: TextType.subheading,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          text: 'Login to your vikn account',
                          type: TextType.body,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _usernameController,
                                iconPath:
                                    'assets/icons/login_icon_username.svg',
                                label: 'Username',
                                hideBorder: false,
                              ),
                              _buildTextField(
                                controller: _passwordController,
                                iconPath:
                                    'assets/icons/login_icon_password.svg',
                                label: 'Password',
                                isPassword: true,
                                hideBorder: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () {},
                          child: CustomText(
                            text: 'Forgotten Password?',
                            type: TextType.body,
                            color: AppColors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: 140,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: 'Sign in',
                                        type: TextType.button,
                                        fontSize: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 80),
                        CustomText(
                          text: 'Don\'t have an Account?',
                          type: TextType.body,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          child: CustomText(
                            text: 'Sign up now!',
                            type: TextType.body,
                            color: AppColors.lightBlueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String iconPath,
    required String label,
    bool isPassword = false,
    bool hideBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: hideBorder
            ? null
            : const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFF0A9EF3),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword && _obscureText,
              style: const TextStyle(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required field';
                }
                if (isPassword && value.length < 5) {
                  return 'Password must be at least 5 characters';
                }
                return null;
              },
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Color(0xFF0A9EF3),
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
