import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../books/presentation/pages/books_list_page.dart';
import '../../../books/presentation/pages/create_book_page.dart';
import '../../../books/presentation/pages/my_books_page.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const BooksListPage(),
    const DiscoverPage(),
    const CreateBookPage(),
    const MyBooksPage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(index);
          },
        ),
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  _pageController.jumpToPage(2);
                },
                backgroundColor: AppColors.primaryGreen,
                child: Icon(Icons.add, color: AppColors.textWhite, size: 28.sp),
              )
            : null,
      ),
    );
  }
}

// Placeholder Pages
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.discover), centerTitle: true),
      body: Center(
        child: Text(
          'Discover Page\nComing Soon',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: user != null
          ? SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      image: user.photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(user.photoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: user.photoUrl == null
                        ? Center(
                            child: Text(
                              user.fullName[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(height: 16.h),

                  // Name
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Username
                  Text(
                    '@${user.username}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(context, 'Books', user.booksCount.toString()),
                      _buildStat(
                        context,
                        'Followers',
                        user.followersCount.toString(),
                      ),
                      _buildStat(
                        context,
                        'Following',
                        user.followingCount.toString(),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Bio
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bio',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            user.bio!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
