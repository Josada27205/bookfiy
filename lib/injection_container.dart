import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:readawwrite_clone/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:readawwrite_clone/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:readawwrite_clone/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Features - Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Features - Books
import 'features/books/data/datasources/book_remote_datasource.dart';
import 'features/books/data/repositories/book_repository_impl.dart';
import 'features/books/domain/repositories/book_repository.dart';
import 'features/books/domain/usecases/create_book_usecase.dart';
import 'features/books/domain/usecases/get_books_usecase.dart';
import 'features/books/domain/usecases/update_book_usecase.dart';
import 'features/books/presentation/bloc/book_bloc.dart';

// Features - Chapters
import 'features/chapters/data/datasources/chapter_remote_datasource.dart';
import 'features/chapters/data/repositories/chapter_repository_impl.dart';
import 'features/chapters/domain/repositories/chapter_repository.dart';
import 'features/chapters/domain/usecases/create_chapter_usecase.dart';
import 'features/chapters/domain/usecases/get_chapters_usecase.dart';
import 'features/chapters/presentation/bloc/chapter_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      storage: sl(),
    ),
  );

  // Features - Books
  // Bloc
  sl.registerFactory(
    () => BookBloc(
      createBookUseCase: sl(),
      getBooksUseCase: sl(),
      updateBookUseCase: sl(),
      bookRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateBookUseCase(sl()));
  sl.registerLazySingleton(() => GetBooksUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBookUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(firestore: sl(), auth: sl(), storage: sl()),
  );

  // Features - Chapters
  // Bloc
  sl.registerFactory(
    () => ChapterBloc(
      createChapterUseCase: sl(),
      getChaptersUseCase: sl(),
      chapterRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateChapterUseCase(sl()));
  sl.registerLazySingleton(() => GetChaptersUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ChapterRepository>(
    () => ChapterRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ChapterRemoteDataSource>(
    () => ChapterRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => Connectivity());
}
