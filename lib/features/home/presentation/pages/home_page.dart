import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../books/presentation/pages/books_list_page.dart';
import '../../../books/presentation/pages/create_book_page.dart';
import '../../../books/presentation/pages/my_books_page.dart';
import '../pages/enhanced_home_page.dart';
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
    const EnhancedHomePage(),
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
      backgroundColor: AppColors.backgroundLight,
      body: user != null
          ? CustomScrollView(
              slivers: [
                // Profile Header
                SliverAppBar(
                  expandedHeight: 280.h,
                  pinned: true,
                  backgroundColor: AppColors.primaryGreen,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Profile Picture
                            Container(
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surface,
                                border: Border.all(
                                  color: AppColors.textWhite,
                                  width: 3,
                                ),
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
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(height: 16.h),

                            // Name
                            Text(
                              user.fullName,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                            SizedBox(height: 4.h),

                            // Username
                            Text(
                              '@${user.username}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textWhite.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // TODO: Navigate to settings
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: AppColors.textWhite,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthSignOutRequested());
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),

                // Stats Cards
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: Offset(0, -20.h),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            context,
                            'หนังสือ',
                            user.booksCount.toString(),
                            Icons.book_rounded,
                          ),
                          _buildDivider(),
                          _buildStatItem(
                            context,
                            'ผู้ติดตาม',
                            user.followersCount.toString(),
                            Icons.people_rounded,
                          ),
                          _buildDivider(),
                          _buildStatItem(
                            context,
                            'กำลังติดตาม',
                            user.followingCount.toString(),
                            Icons.person_add_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Bio Section
                      if (user.bio != null && user.bio!.isNotEmpty) ...[
                        _buildSectionTitle('เกี่ยวกับฉัน'),
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            user.bio!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Menu Items
                      _buildSectionTitle('เมนู'),
                      SizedBox(height: 12.h),
                      _buildMenuItem(
                        context,
                        icon: Icons.edit,
                        title: 'แก้ไขโปรไฟล์',
                        onTap: () {
                          // TODO: Navigate to edit profile
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.favorite_rounded,
                        title: 'หนังสือที่ชอบ',
                        onTap: () {
                          // TODO: Navigate to liked books
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.history_rounded,
                        title: 'ประวัติการอ่าน',
                        onTap: () {
                          // TODO: Navigate to reading history
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.help_rounded,
                        title: 'ช่วยเหลือ',
                        onTap: () {
                          // TODO: Navigate to help
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.info_rounded,
                        title: 'เกี่ยวกับแอพ',
                        onTap: () {
                          // TODO: Navigate to about
                        },
                      ),
                    ]),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: AppColors.primaryGreen),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40.h, width: 1, color: AppColors.divider);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.primaryGreen),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}
