import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/brand_config.dart';
import 'core/config/retail_config.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/layout_repository_impl.dart';
import 'injection_container.dart';
import 'presentation/cubit/checkout_cubit.dart';
import 'presentation/cubit/payment_content_cubit.dart';
import 'presentation/pages/payment_screen.dart';
import 'presentation/widgets/root_guard.dart';
import 'presentation/widgets/screen_recording_guard.dart';
import 'presentation/widgets/secure_window.dart';

void main() {
  const config = RetailConfig();
  configureDependencies(
    config: config,
    layout: LayoutRepositoryImpl(config.loadAssets),
  );

  runApp(
    RepositoryProvider<BrandConfig>.value(
      value: config,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<PaymentContentCubit>()..load()),
          BlocProvider(create: (_) => sl<CheckoutCubit>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.retailShop(),
          home: const RootGuard(
            child: SecureWindow(
              child: ScreenRecordingGuard(
                child: PaymentScreen(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
