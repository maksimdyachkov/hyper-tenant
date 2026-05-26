import 'package:get_it/get_it.dart';

import 'core/config/brand_config.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'data/service/payment_processing_service_impl.dart';
import 'data/service/security_service_impl.dart';
import 'domain/repositories/layout_repository.dart';
import 'domain/repositories/payment_repository.dart';
import 'domain/services/payment_processing_service.dart';
import 'domain/services/security_service.dart';
import 'presentation/cubit/checkout_cubit.dart';
import 'presentation/cubit/payment_content_cubit.dart';

final sl = GetIt.instance;

void configureDependencies({
  required BrandConfig config,
  required LayoutRepository layout,
}) {
  sl
    ..registerLazySingleton<BrandConfig>(() => config)
    ..registerLazySingleton<LayoutRepository>(() => layout)
    ..registerLazySingleton<SecurityService>(() => SecurityServiceImpl())
    ..registerLazySingleton<PaymentProcessingService>(
        () => PaymentProcessingServiceImpl())
    ..registerLazySingleton<PaymentRepository>(
        () => PaymentRepositoryImpl(loadAssets: sl<BrandConfig>().loadAssets))
    ..registerFactory(
        () => PaymentContentCubit(paymentRepo: sl(), layoutRepo: sl()))
    ..registerFactory(() => CheckoutCubit(security: sl(), processing: sl()));
}
