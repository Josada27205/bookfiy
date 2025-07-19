import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/constants/app_themes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/books/presentation/bloc/book_bloc.dart';
import 'features/chapters/presentation/bloc/chapter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'features/home/presentation/pages/home_page.dart';
import 'features/books/presentation/pages/create_book_page.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase - check if already initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase already initialized
    debugPrint('Firebase already initialized');
  }

  // Initialize dependencies
  await di.init();

  // Set system UI overlays
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<AuthBloc>()),
            BlocProvider(create: (_) => di.sl<BookBloc>()),
            BlocProvider(create: (_) => di.sl<ChapterBloc>()),
          ],
          child: MaterialApp(
            title: 'Bookify',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            localizationsDelegates: const [
              FlutterQuillLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US')],
            home: const SplashPage(),
            routes: {
              '/splash': (context) => const SplashPage(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => const HomePage(),
              '/create-book': (context) => const CreateBookPage(),
            },
          ),
        );
      },
    );
  }
}
