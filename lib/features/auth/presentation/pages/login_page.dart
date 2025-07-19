import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Center(
                    child: Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.book_rounded,
                        size: 40.sp,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Sign in to continue reading and writing',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    labelText: AppStrings.email,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                  ),
                  SizedBox(height: 20.h),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    labelText: AppStrings.password,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: Validators.password,
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: Text(
                        AppStrings.forgotPassword,
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  AuthButton(
                    text: AppStrings.signIn,
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: AppColors.divider, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: AppColors.divider, thickness: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  AuthButton(
                    text: 'Continue with Google',
                    onPressed: () {
                      // TODO: Implement Google Sign In
                    },
                    isOutlined: true,
                    icon: Icons.g_mobiledata_rounded,
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAccount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: Text(
                          AppStrings.signUp,
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
