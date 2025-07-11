import 'package:get_it/get_it.dart';
import 'package:try_app/src/core/network/dio/dio_provider.dart';
import 'package:try_app/src/core/network/interceptors/auth_interceptors.dart';
import 'package:try_app/src/core/services/token_storeage.dart';
import 'package:try_app/src/features/auth/data/remote_data_source/login_remote_datasource.dart';
import 'package:try_app/src/features/auth/data/repository/login_repository_impl.dart';
import 'package:try_app/src/features/auth/domain/repository/login_repository.dart';
import 'package:try_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:try_app/src/features/auth/presentation/cubit/cubit/login_cubit.dart';
import 'package:try_app/src/features/site_listing/data/repository_impl/sitelisting_repo_impl.dart';
import 'package:try_app/src/features/site_listing/data/site_listing_remote_datasource/site_listing_datasource.dart';
import 'package:try_app/src/features/site_listing/domain/repository/site_listing_repository.dart';
import 'package:try_app/src/features/site_listing/domain/usecases/siteListingUsecase.dart';
import 'package:try_app/src/features/site_listing/presentation/cubit/site_listing_cubit.dart';
final sl = GetIt.instance;

Future<void> init() async {
  // Core
  // sl.registerLazySingleton(() => Dio());
  final dio = createDioClient();
  sl.registerLazySingleton(() => dio);
//added this on good working code
  sl.registerLazySingleton(()=>AuthInterceptor(tokenStorage: sl(), dio: sl()));
  // Data Layer
  sl.registerLazySingleton<LoginRemoteDatasource>(
    () => LoginRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(sl()),
  );

  // Domain Layer
  sl.registerLazySingleton(() => LoginUsecase(sl()));

  // Presentation Layer
  sl.registerFactory(() => LoginCubit(sl(),sl()));

  sl.registerLazySingleton(() => TokenStorage());
sl.registerLazySingleton(()=>SiteListingCubit(sl()));
sl.registerLazySingleton(()=>SitelistingUsecase(repository:sl()));
sl.registerLazySingleton<SiteListingRemoteDatasource>(()=> SiteListingRemoteDatasourceImpl(sl()));
sl.registerLazySingleton<SiteListingRepository>(()=>SiteListingRepositoryImpl(siteListingRemoteDatasource: sl()));

}
