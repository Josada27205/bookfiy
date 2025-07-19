import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  void _checkAuthStatus() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckRequested());
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 120.w,
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(30.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.book_rounded,
                            size: 60.sp,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30.h),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            AppStrings.appName,
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            AppStrings.appTagline,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textWhite.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 80.h),
                SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.textWhite.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
