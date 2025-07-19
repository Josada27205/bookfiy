import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignUpRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          fullName: _fullNameController.text.trim(),
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
                  SizedBox(height: 20.h),
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
                  SizedBox(height: 30.h),
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Start your journey as a writer and reader',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  AuthTextField(
                    controller: _fullNameController,
                    hintText: 'Enter your full name',
                    labelText: AppStrings.fullName,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: Validators.fullName,
                  ),
                  SizedBox(height: 16.h),
                  AuthTextField(
                    controller: _usernameController,
                    hintText: 'Choose a username',
                    labelText: AppStrings.username,
                    prefixIcon: Icons.alternate_email,
                    textInputAction: TextInputAction.next,
                    validator: Validators.username,
                  ),
                  SizedBox(height: 16.h),
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    labelText: AppStrings.email,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                  ),
                  SizedBox(height: 16.h),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: 'Create a password',
                    labelText: AppStrings.password,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    validator: Validators.password,
                  ),
                  SizedBox(height: 16.h),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm your password',
                    labelText: AppStrings.confirmPassword,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) => Validators.confirmPassword(
                      _passwordController.text,
                      value,
                    ),
                    onFieldSubmitted: (_) => _handleRegister(),
                  ),
                  SizedBox(height: 30.h),
                  AuthButton(
                    text: AppStrings.signUp,
                    onPressed: _handleRegister,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'By signing up, you agree to our ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to Terms of Service
                        },
                        child: Text(
                          'Terms',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        ' and ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to Privacy Policy
                        },
                        child: Text(
                          'Privacy',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.alreadyHaveAccount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          AppStrings.signIn,
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
